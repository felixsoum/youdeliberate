class AdminController < ApplicationController

  # GET /admin
  def index
    @upload_message = "Upload a narrative in zip format"
  end

  # POST admin/upload
  def upload
    narratives_zip = params[:narrative]
    if narratives_zip.nil?
      flash.now[:error] = "Failed. Nothing to upload."
      #@upload_message = "Failed. Nothing to upload"
      #render :index
    elsif narratives_zip.content_type != "application/zip" and
          narratives_zip.content_type != "application/octet-stream" and
          narratives_zip.content_type != "application/x-zip-compressed"
      # The MIME type of a zip file is sometimes octet-stream. Read more: http://stackoverflow.com/questions/856013/mime-type-for-zip-file-in-google-chrome
      #@upload_message = "Failed. Please choose a zip file."
      #render :index
      flash.now[:error] = "Failed. Please choose a zip file."
    else
      require 'rubygems'
      require 'zip'
      upload_narratives(narratives_zip)
    end
    redirect_to narratives_path
  end

  private
    def upload_narratives narratives_zip
      Zip::File.open(narratives_zip.path) do |zip_file|
        # Create unique directory name for the next narrative
        narrative_number = get_narrative_counter.value
        narratives_path = get_narratives_path
        narratives_unzip_pathes = get_narratives_unzip_pathes(zip_file, narrative_number)
        extract_files(zip_file, narratives_path, narratives_unzip_pathes)
        update_database(narratives_unzip_pathes, narratives_path)
        number_of_uploaded_narrative = narratives_unzip_pathes.length
        narrative_number = narrative_number + number_of_uploaded_narrative
        set_counter_value(get_narrative_counter, narrative_number)
        flash.now[:success] = "#{number_of_uploaded_narrative} narrative(s) has been Uploaded to server successfully."
      end
    end

    def get_narrative_counter
      # Make sure narrative count exists
      if NarrativeCount.count == 0
        NarrativeCount.create(value: 1000)
      end
      return NarrativeCount.find(1)
    end

    def get_narratives_path
      upload_path = params[:upload_path]
      if(upload_path)
        upload_path = Rails.root.join('public', 'narratives').to_s
      end
      narratives_path = upload_path
    end

    #Use xml to count the number of narratives that need to be uploaded
    #Also store its path inside the zip with corresponding narrative number in a hash
    def get_narratives_unzip_pathes zip_file, narrative_number
      number_after_upload_narrative = narrative_number
      narratives_unzip_pathes = Hash.new
      zip_file.each do |file|
        file_with_folder_name = file.name
        if (file_with_folder_name.last(4) == ".xml")
          number_after_upload_narrative = number_after_upload_narrative + 1
          if (position_of_last_slash = file_with_folder_name.rindex('/'))
            narratives_unzip_pathes[file_with_folder_name.to(
              position_of_last_slash)] = number_after_upload_narrative
          else
            narratives_unzip_pathes[""] = number_after_upload_narrative
          end
        end
      end
      return narratives_unzip_pathes
    end

    def set_counter_value counter, new_count_value
      counter.value = new_count_value
      counter.save
    end

    def extract_files zip_file, narratives_path, narratives_unzip_pathes
      zip_file.each do |file|
        file_with_folder_name = file.name
        if (position_of_last_slash = file_with_folder_name.rindex('/'))
          #Ignore empty folder
          next if(! nar_number = narratives_unzip_pathes[
            file_with_folder_name.to(position_of_last_slash)])
          folder_path = "#{narratives_path}/#{nar_number}"
          file_name = file_with_folder_name.from(position_of_last_slash + 1)
        else
          folder_path = "#{narratives_path}/#{narratives_unzip_pathes[""]}"
          file_name = file_with_folder_name
        end
        file_path = File.join(folder_path, file_name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(file, file_path) unless File.exist?(file_path)
      end
    end

    def update_database narratives_unzip_pathes, narratives_path
      narratives_unzip_pathes.each do |key, value|
        narrative_path = "#{narratives_path}/#{value}"
        parse_xml_to_database(narrative_path)
        insert_image_audio_to_database(narrative_path)
      end
    end

    def parse_xml_to_database narrative_path
      Dir.foreach(narrative_path) do |file|
        if File.extname(file) == ".xml"
          xml_file = File.open(File.join(narrative_path, file))
          doc = Nokogiri::XML(xml_file)
          nar_info = doc.xpath("//narrative")
          narrative_name = nar_info.xpath("//narrativeName").text
          narrative_language = (nar_info.xpath("//language").text).capitalize()
          narrative_language_id = get_language_id(narrative_language)
          nar_date = nar_info.xpath("//submitDate").text
          nar_time = (nar_info.xpath("//time").text).gsub("-", ":")
          nar_create_time = "#{nar_date} #{nar_time}"
          relative_narrative_path = narrative_path.from(
            narrative_path.index('narratives/'))
          @narrative = Narrative.create(
            nar_name: narrative_name, nar_path: relative_narrative_path,
            language_id: narrative_language_id, category_id: 3,
            num_of_view: 0, num_of_agree: 0, num_of_disagree: 0,
            num_of_flagged: 0, create_time: nar_create_time)
          xml_file.close
        end
      end
    end

    def insert_image_audio_to_database narrative_path
      accepted_audio_formats = [".mp3", ".wav",".3gp"]
      accepted_image_formats = [".jpg", ".png"]
      Dir.foreach(narrative_path) do |file|
        next if file == '.' or file == '..'
        relative_narrative_path = narrative_path.from(
          narrative_path.index('narratives/'))
        insert_to_table(file, accepted_audio_formats,
          relative_narrative_path, Audio)
        insert_to_table(file, accepted_image_formats,
          relative_narrative_path, Image)
      end
    end

    def insert_to_table file, file_formats, path, type
      if file_formats.include? File.extname(file)
        class_name = type.to_s.downcase
        instance_data = {"#{class_name}_path"=> "#{path}/#{file}",
                     "narrative_id"=> @narrative.id,
                     "#{class_name}_number"=> File.basename(file, '.*')}
        type.create(instance_data)
      end
    end

    def get_language_id language
      Language.select("id").where(language_name: language)
    end

end