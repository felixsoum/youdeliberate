class AdminController < ApplicationController
  @@accepted_audio_formats = [".mp3", ".wav"]
  @@accepted_image_formats = [".jpg", ".png"]

  # POST admin/upload
  def upload
    narratives_zip = params[:narrative]
    if narratives_zip.nil?
      flash[:error] = "Failed. Nothing to upload."
    elsif narratives_zip.content_type != "application/zip" and
          narratives_zip.content_type != "application/octet-stream" and
          narratives_zip.content_type != "application/x-zip-compressed"
      # The MIME type of a zip file is sometimes octet-stream. Read more: http://stackoverflow.com/questions/856013/mime-type-for-zip-file-in-google-chrome
      flash[:error] = "Failed. Please choose a zip file."
    else
      require 'rubygems'
      require 'zip'
      require "mp3info"
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
        invalid_narratives = Array.new
        narratives_unzip_pathes = get_narratives_unzip_pathes(zip_file, narrative_number, invalid_narratives)
        if (!narratives_unzip_pathes.empty?)
#          extract_files(zip_file, narratives_path, narratives_unzip_pathes)
#          update_database(narratives_unzip_pathes, narratives_path)
          number_of_uploaded_narrative = narratives_unzip_pathes.length
#          narrative_number = narrative_number + number_of_uploaded_narrative
#          set_counter_value(get_narrative_counter, narrative_number)
          flash[:success] = get_message(number_of_uploaded_narrative, invalid_narratives)
        else
          flash[:error] = "There are invalid files in narratives.(For file format just mp3, wav, jpg and png are supported)"
        end
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
      if(upload_path == "")
        upload_path = Rails.root.join('public', 'narratives').to_s
      end
      narratives_path = upload_path
    end

    #Use xml to count the number of narratives that need to be uploaded
    #Also store its path inside the zip with corresponding narrative number in a hash
    def get_narratives_unzip_pathes zip_file, narrative_number, invalid_narratives
      number_after_upload_narrative = narrative_number
      narratives_unzip_pathes = Hash.new
      narratives_possible_pathes = Array.new
      zip_file.each do |file|
        file_name_with_folder_path = file.name
        add_to_possible_pathes(file_name_with_folder_path, narratives_possible_pathes)
        add_to_invalid_pathes(file_name_with_folder_path, invalid_narratives)
      end
      narratives_possible_pathes.each do |path|
        unless (invalid_narratives.include?(path))
          number_after_upload_narrative = number_after_upload_narrative + 1
          narratives_unzip_pathes[path] = number_after_upload_narrative
        end
      end
      return narratives_unzip_pathes
    end

    def add_to_possible_pathes file_name_with_folder_path, narratives_possible_pathes
      if (file_name_with_folder_path.last(4) == ".xml")
        folder_path = get_path_without_file_name(file_name_with_folder_path)
        narratives_possible_pathes << folder_path
      end
    end

    def add_to_invalid_pathes file_name_with_folder_path, narratives_invalid_pathes
      if file_name_with_folder_path.last(1) != "/"
        unless ((@@accepted_audio_formats + @@accepted_image_formats + [".xml"]).include?(file_name_with_folder_path.last(4)))
          folder_path = get_path_without_file_name(file_name_with_folder_path)
          narratives_invalid_pathes << folder_path
        end
      end
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
        insert_audio_length_for_narrative(narrative_path)
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

    def insert_audio_length_for_narrative narrative_path
        total_length = 0;
        
        # Cycle through each audio file in that narrative's folder to compute the total audio length. 
        Dir.foreach(narrative_path) do |file|
          if @@accepted_audio_formats.include? File.extname(file)
            Mp3Info.open(narrative_path + "/" + file) do |mp3info|
              total_length += mp3info.length
            end
          end
          
          Narrative.update(@narrative.id, :total_audio_length => total_length)
       end
    end

    def insert_image_audio_to_database narrative_path      
      Dir.foreach(narrative_path) do |file|
        next if file == '.' or file == '..'
        relative_narrative_path = narrative_path.from(
          narrative_path.index('narratives/'))
        insert_to_table(file, @@accepted_audio_formats,
          relative_narrative_path, Audio)
        insert_to_table(file, @@accepted_image_formats,
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

    def get_path_without_file_name file_name_with_folder_path
      if (position_of_last_slash = file_name_with_folder_path.rindex('/'))
        return file_name_with_folder_path.to(position_of_last_slash)
      else
        return ""
      end      
    end

    def get_message number_of_uploaded_narrative, invalid_narratives
      if (invalid_narratives.empty?)
        return "#{number_of_uploaded_narrative} narrative(s) has been Uploaded to server successfully."
      else 
        return "#{number_of_uploaded_narrative} narrative(s) has been Uploaded to server successfully. However, narratives #{invalid_narratives.join(",")} are not uploaded since there are invalid files."
      end
    end

end