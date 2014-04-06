module XmlHelper

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

end
