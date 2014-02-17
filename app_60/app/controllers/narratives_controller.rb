class NarrativesController < ApplicationController
  include NarrativesHelper
  before_action :set_narrative, only: [:show, :edit, :update, :destroy]

  # GET /narratives
  # GET /narratives.json
  def index
    @narratives = Narrative.all
    respond_to do |format|
      format.html
      # Support JSONP. Read more: http://henrysztul.info/post/14970402595/how-to-enable-jsonp-support-in-a-rails-app
      format.json { render :json => narratives_json(@narratives), :callback => params[:callback] }
    end
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

  # GET /narratives/new
  def new
    @narrative = Narrative.new
  end

  # GET /narratives/1/edit
  def edit
  end
  
    # GET /narratives/play/1
  def play   
    @narrative = Narrative.find(params[:id])
    
    root = "http://localhost:3000/"

    audio_array = []
    Audio.where(narrative_id: params[:id]).each do |audio|
      image_path = Image.where(narrative_id: params[:id]).where("image_number <= ?", audio.audio_number).pluck(:image_path).last || "narratives/default_narrative_image.jpg"      
      audio_array.push(  
        #mp3: Rails.public_path + audio.audio_path,
        mp3: root + audio.audio_path,
        poster: root + image_path      
      )
    end
    @audio_json = audio_array.to_json.html_safe 
  end

  # POST /narratives
  # POST /narratives.json
  def create
    @narrative = Narrative.new(narrative_params)

    respond_to do |format|
      if @narrative.save
        format.html { redirect_to @narrative, notice: 'Narrative was successfully created.' }
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
        format.html { redirect_to @narrative, notice: 'Narrative was successfully updated.' }
        format.json { head :no_content }
      else
        render_after_fail(format, 'edit')
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_narrative
      @narrative = Narrative.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def narrative_params
      params.require(:narrative).permit(:nar_name, :nar_path, :language_id, :category_id, :first_image,
                                        :num_of_view, :num_of_agree, :num_of_disagree, :num_of_flagged, :create_time)
    end
    
    def render_after_fail format, act
      format.html { render action: act }
      format.json { render json: @narrative.errors, status: :unprocessable_entity }
    end
end
