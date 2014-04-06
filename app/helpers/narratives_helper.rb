module NarrativesHelper

  def narratives_json(narratives)

    list = narratives.order(:category_id).map do |narrative|
      narrative_json(narrative)
    end
    {:name => "Narratives", :children => list
    }.to_json
  end

  def narrative_json(narrative)
        { :id => "#{narrative.id}",
          :name => narrative.nar_name,
          :language => narrative.language_id,
          :numberAgree => narrative.num_of_agree,
          :numberDisagree => narrative.num_of_disagree,
          :numberViews => narrative.num_of_view,
          :numberComments => narrative.n_comments.count,
          :narrativeID => narrative.id,
          :category => narrative.category_id,
          :uploadTime => narrative.updated_at
        }
  end

  def sunburst_json(narratives)

    list = narratives.group(:category_id).count.map do |key, value|
      sunburst_list(key, value)
    end

    {
      :name => "Narratives", :children => list
    }.to_json
  end

  def sunburst_list(key, value)
    {
      :category_id => key,
      :count => value
    }
  end

  def get_comments_for_narrative narrative_id
    NComment.where(narrative_id: narrative_id).order("created_at DESC")
  end

  def get_language_name language_id
    Language.find(language_id).language_name
  end

  def get_category_name category_id
    Category.find(category_id).category_name
  end

  def get_flagged_content    
    flagged_content_array = Array.new
    if (cookies[:flagged])
      flagged_string = cookies[:flagged]
      flagged_string.lines.each do |line|
          flagged_content_array << line.split(',').map(&:chomp)
      end
    end
    return flagged_content_array
  end
  
  def save_flagged_content type, id
    flagged_str = ""
    flagged_content = get_flagged_content
    flagged_content.push([type, id.to_s])
    
    flagged_content.each do |line|
      flagged_str  << line.join(",") + "\n"
    end
    cookies[:flagged] = flagged_str
  end
  
  def is_flagged? passed_type, passed_id
    flagged_content = get_flagged_content
    !flagged_content.select{ |type, id| type == passed_type.to_s && id == passed_id.to_s}.empty?
  end

end