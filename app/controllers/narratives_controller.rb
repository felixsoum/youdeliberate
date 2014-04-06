# encoding: utf-8
class NarrativesController < ApplicationController
  include NarrativesHelper
  before_action :set_narrative, only: [:show, :edit, :update, :destroy]
  before_filter :require_login, :except => [:play, :comment, :flag, :agree, :disagree, :undo_agree, :undo_disagree], :unless => :format_json?

  # GET /narratives
  # GET /narratives.json
  def index
    @narratives = Narrative.all
    published_narratives = Narrative.where(is_published: true)
    render_to_home(narratives_json(published_narratives))
  end

  def setting
  end

  # GET /narratives/1
  # GET /narratives/1.json
  def show
    @narrative = Narrative.find(params[:id])
    
    respond_to do |format|
      format.html
      # Support JSONP. Read more: http://henrysztul.info/post/14970402595/how-to-enable-jsonp-support-in-a-rails-app
      format.json { render :json => narrative_json(@narrative), :callback => params[:callback] }
    end
  end

  # GET /sunburst
  # GET /sunburst.json
  def sunburst
    @narratives = Narrative.all
    published_narratives = Narrative.where(is_published: true)
    render_to_home(sunburst_json(published_narratives))
  end

  # GET /narratives/new
  def new
    @narrative = Narrative.new
  end

  # GET /narratives/1/edit
  def edit
  end
  
  # GET /narratives/1/play/
  def play
    selected_narrative_id = params[:id]
    @narrative = Narrative.find(selected_narrative_id)
    audio_array = []
    fill_audio_array audio_array, selected_narrative_id
    @audio_json = audio_array.to_json.html_safe
    @comments = get_comments_for_narrative(selected_narrative_id)
    @audio_count = audio_array.size
    @share_link = share_narrative_url params[:id].strip
    Narrative.increment_counter(:num_of_view, selected_narrative_id)
  end

  # POST narratives/1/comment
  def comment
    narrative_id = params[:id]
    NComment.create(content: params[:user_submitted_comment], narrative_id: narrative_id)
    @comments = get_comments_for_narrative(narrative_id)
    respond_to do |format|
      format.js
    end
  end
  
  # DELETE narratives/1/comment/1/remove/
  def remove_comment
    narrative_id = params[:id]
    comment = NComment.find(params[:comment_id])
    comment.update(:content => 'Commentaire supprimé / Comment removed')
    @comments = get_comments_for_narrative(narrative_id)
    respond_to do |format|
      format.js { render 'comment.js.erb' }
    end
  end

  # POST narratives/1/flag
  def flag
    narrative_id = params[:id]
    if (params.has_key?(:comment_id) && params[:comment_id] != "" && !is_flagged?("comment", params[:comment_id]))
      NComment.increment_counter(:num_flags, params[:comment_id])
      FlagMailer.flag_comment_email(narrative_id, params[:comment_id], params[:flag]).deliver
      save_flagged_content("comment", params[:comment_id])
    elsif (!is_flagged? "narrative", narrative_id.to_s)
      Narrative.increment_counter(:num_of_flagged, narrative_id)
      FlagMailer.flag_narrative_email(narrative_id, params[:flag]).deliver
      save_flagged_content("narrative", narrative_id)
    end
    redirect_to(:action => "play", :id => narrative_id)
  end
  
  # POST narratives/1/agree
  def agree
    is_ok = Narrative.increment_counter(:num_of_agree, params[:id])
    return_status_code is_ok
  end
  
  # POST narratives/1/disagree
  def disagree
    is_ok = Narrative.increment_counter(:num_of_disagree, params[:id])
    return_status_code is_ok
  end
  
  # POST narratives/1/undo_agree
  def undo_agree
    is_ok = Narrative.decrement_counter(:num_of_agree, params[:id])
    return_status_code is_ok
  end
  
  # POST narratives/1/undo_disagree
  def undo_disagree
    is_ok = Narrative.decrement_counter(:num_of_disagree, params[:id])
    return_status_code is_ok    
  end
  
  # POST /narratives
  # POST /narratives.json
  def create
    @narrative = Narrative.new(narrative_params)

    respond_to do |format|
      if @narrative.save
        format.html { redirect_to @narrative,
                                  notice: 'Narrative was successfully created.' }
        format.json { render action: 'show', status: :created, location: @narrative }
      else
        render_after_fail(format, 'new')
      end
    end
  end

  # PATCH/PUT /narratives/1
  # PATCH/PUT /narratives/1.json
  def update
    respond_to do |format|
      if @narrative.update(narrative_params)
        format.html { redirect_to admin_list_path }
        format.json { head :no_content }
        flash[:success] = "The narrative has been updated."
      else
        #render_after_fail(format, 'edit')
        flash[:error] = "Fail.The narrative cannot be updated."
      end
    end
  end

  # POST /narratives/save
  def save
    # Convert hash keys from String to Int
    converted_params = Hash[params[:narrative_attributes].map {|k, v| [k.to_i, v] }]
    # Whitelist params
    safe_params = ActionController::Parameters.new(converted_params)
    # Track success of save
    is_saved = true
    # Commit all updates in a single transaction
    Narrative.transaction do
      # ActiveRecord guarantees that only changed objects will be saved in the transaction
      Narrative.all.each do |narrative|
        is_saved = is_saved and narrative.update(safe_params.require(narrative.id).permit(:nar_name, :language_id, :category_id, :is_published))
      end
    end
    # Flash save status
    if is_saved
      flash[:success] = "The narratives have been saved."
    else
      flash[:error] = "There was a problem saving the narratives..."
    end
    redirect_to admin_list_path
  end

  # DELETE /narratives/1
  # DELETE /narratives/1.json
  def destroy
    FileUtils.rm_rf(Rails.public_path + @narrative.nar_path)
    @narrative.destroy
    respond_to do |format|
      format.html { redirect_to admin_list_path }
      format.json { head :no_content }
    end
    flash[:success] = "The narrative has been delete."
  end

  private
    def return_status_code is_ok
      respond_to do |format|
        if is_ok == 1
          format.json { head :ok }
        else
          format.json { head :error }
        end 
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_narrative
      @narrative = Narrative.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def narrative_params
      params.require(:narrative).permit(:nar_name, :nar_path, :language_id,
                                        :category_id, :first_image,
                                        :num_of_view, :num_of_agree,
                                        :num_of_disagree, :num_of_flagged,
                                        :create_time, :is_published)
    end

    def render_after_fail format, act
      format.html { render action: act }
      format.json { render json: @narrative.errors, status: :unprocessable_entity }
    end

    def render_to_home json_data
      respond_to do |format|
        format.html
        # Support JSONP. Read more: http://henrysztul.info/post/14970402595/how-to-enable-jsonp-support-in-a-rails-app
        format.json { render :json => json_data, :callback => params[:callback] }
      end
    end

    def require_login
      unless signed_in?
        redirect_to signin_path
      end
    end
    
    def format_json?
      request.format.json?
    end
end
