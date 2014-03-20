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
    images = Image.where(narrative_id: selected_narrative_id)
    default_image_path = images.first.try(:image_path) || "default_narrative_image.jpg"
    audio_array = []
    Audio.where(narrative_id: selected_narrative_id).each do |audio|
      image_path = images.where("image_number <= ?", audio.audio_number).last.try(:image_path) || default_image_path
      audio_array.push(mp3: root_url + audio.audio_path, poster: root_url + image_path)
    end
    @audio_json = audio_array.to_json.html_safe
    @comments = get_comments_for_narrative(selected_narrative_id)
    @audio_count = audio_array.size
    @share_link = share_narrative_url params[:id].strip
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

  # POST narratives/1/flag
  def flag
      flagged_narratives = get_flagged_narratives
      narrative_id = params[:id]
    if (!flagged_narratives.include? narrative_id.to_s)
      @narrative = Narrative.find(narrative_id)
      flag = @narrative.num_of_flagged + 1
      @narrative.update(num_of_flagged: flag)
      FlagMailer.flag_reason_email(narrative_id, params[:flag]).deliver
      flagged_narratives.push(narrative_id.to_s)
      save_flagged_narratives(flagged_narratives)
      redirect_to(:action => "play", :id => narrative_id)
    else
      redirect_to(:action => "play", :id => narrative_id)
    end
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
        format.html { redirect_to narratives_url }
        format.json { head :no_content }
        flash[:success] = "The narrative has been updated."
      else
        #render_after_fail(format, 'edit')
        flash[:error] = "Fail.The narrative cannot be updated."
      end
    end
  end

  # DELETE /narratives/1
  # DELETE /narratives/1.json
  def destroy
    FileUtils.rm_rf(@narrative.nar_path)
    @narrative.destroy
    respond_to do |format|
      format.html { redirect_to narratives_url }
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
