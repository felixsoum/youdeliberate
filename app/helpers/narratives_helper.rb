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

  def get_flagged_narratives
    flagged_narratives_array = Array.new
    if (cookies[:flagged])
      flagged_narratives_string = cookies[:flagged]
      flagged_narratives_array = flagged_narratives_string.split(",")
    end
    return flagged_narratives_array
  end
  
  def save_flagged_narratives flagged_narratives
    cookies[:flagged] = flagged_narratives.join(",")
  end
  
  def is_flagged? narrative_id
    flagged_narratives = get_flagged_narratives
    flagged_narratives.include? narrative_id.to_s
  end

end