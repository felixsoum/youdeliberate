class AdminController < ApplicationController

  # GET /admin
  def index
    @upload_message = "Upload a narrative in zip format"
  end

  # POST admin/upload
  def upload
    if params[:narrative].nil?
      @upload_message = "Failed. Nothing to upload"
      render :index
    elsif params[:narrative].content_type != "application/zip" and
          params[:narrative].content_type != "application/octet-stream"
      # The MIME type of a zip file is sometimes octet-stream. Read more: http://stackoverflow.com/questions/856013/mime-type-for-zip-file-in-google-chrome
      @upload_message = "Failed. Please choose a zip file."
      render :index
    else
      require 'rubygems'
      require 'zip'

      Zip::File.open(params[:narrative].path) do |zip_file|
        # Create unique directory name for the next narrative
        narrative_number = get_narrative_counter.value + 1

        narrative_path = Rails.root.join('public', 'narratives', narrative_number.to_s).to_s

        extract_files(zip_file, narrative_path)

        parse_xml_to_database(narrative_path)

        set_counter_value(get_narrative_counter, narrative_number)

        insert_image_audio_to_database(narrative_path)
      end
      @result = "Upload completed"
    end
  end
  
  private
    #
    def get_narrative_counter
      # Make sure narrative count exists
      if NarrativeCount.count == 0
        NarrativeCount.create(value: 1000)
      end

      return NarrativeCount.find(1)
    end

    def set_counter_value counter, new_count_value
      counter.value = new_count_value
      counter.save
    end

    def extract_files zip_file, folder_path
      zip_file.each do |file|
        file_path = File.join(folder_path, file.name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(file, file_path) unless File.exist?(file_path)
      end
    end

    def parse_xml_to_database narrative_path
      Dir.foreach(narrative_path) do |file|
        if File.extname(file) == ".xml"
          doc = Nokogiri::XML(File.open(File.join(narrative_path, file)))
          nar_info = doc.xpath("//narrative")
          narrative_name = nar_info.xpath("//narrativeName").text
          narrative_language = nar_info.xpath("//language").text
          narrative_language_id = get_language_id(narrative_language)
          nar_date = nar_info.xpath("//submitDate").text
          nar_time = nar_info.xpath("//time").text
          @narrative = Narrative.create(nar_name: narrative_name, nar_path: narrative_path,
                                        language_id: narrative_language_id, num_of_view: 0,
                                        num_of_agree: 0, num_of_disagree: 0, num_of_flagged: 0)
        end
      end
    end

    def insert_image_audio_to_database narrative_path
      accepted_audio_formats = [".mp3", ".wav","3gp"]
      accepted_image_formats = [".jpg", ".png"]
      Dir.foreach(narrative_path) do |file|
        next if file == '.' or file == '..'
        if accepted_audio_formats.include? File.extname(file)
          Audio.create(audio_path: "#{narrative_path}/#{file}",
                       narrative_id: @narrative.id)
        elsif accepted_image_formats.include? File.extname(file)
          Image.create(image_path: "#{narrative_path}/#{file}",
                       narrative_id: @narrative.id)
        end
      end
    end
    
    def get_language_id language
      query = "SELECT id FROM languages WHERE language_name = \'#{language}\'"
      result = ActiveRecord::Base.connection.execute(query).first;
      if result != nil
        return narrative_language = result["id"]
      else
        return 1
      end
    end

end