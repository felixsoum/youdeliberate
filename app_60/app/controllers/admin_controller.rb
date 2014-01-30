class AdminController < ApplicationController
  def index
  end

  def upload
    require 'rubygems'
    require 'zip'
  	Zip::File.open(params[:narrative].path) do |zip_file|

      # Make sure narrative count exists
      if NarrativeCount.count == 0
        NarrativeCount.create(value: 0)
      end

      # Create unique directory name for the next narrative
      count = NarrativeCount.find(1)
      count.value = count.value + 1

      # Set default value for database insertion
      narrative_name = count.value
      narrative_path = Rails.root.join('public', 'narratives', count.value.to_s).to_s
      narrative_language = 1
      
      # Extract files
		  zip_file.each do |file|
		    file_path = File.join(narrative_path, file.name)
		    FileUtils.mkdir_p(File.dirname(file_path))
		    zip_file.extract(file, file_path) unless File.exist?(file_path)
		    
		    # If the file is xml read the narrative information
		    if File.extname(file.name) == ".xml"
		      doc = Nokogiri::XML(File.open(file_path)) 
          nar_info = doc.xpath("//narrative") 
          narrative_name = nar_info.xpath("//narrativeName").text
          #narrative_language = nar_info.xpath("//language").text
          nar_date = nar_info.xpath("//submitDate").text
          nar_time = nar_info.xpath("//time").text          
		    end    
      end
      
      @narrative = Narrative.create(nar_name: narrative_name, nar_path: narrative_path, language_id: narrative_language,
                                     num_of_view: 0, num_of_agree: 0, num_of_disagree: 0, num_of_flagged: 0)

      # Save the incremented count after insertion is succesful
      count.save

      # Update audio and image table in database
      accepted_audio_formats = [".mp3", ".wav","3gp"]
      accepted_image_formats = [".jpg", ".png"]
      Dir.foreach(narrative_path) do |file|
        next if file == '.' or file == '..'
        if accepted_audio_formats.include? File.extname(file)
          Audio.create(audio_path: "#{narrative_path}/#{file}", narrative_id: @narrative.id)
        elsif accepted_image_formats.include? File.extname(file)
          Image.create(image_path: "#{narrative_path}/#{file}", narrative_id: @narrative.id)
        end
      end
    end
  end
end
