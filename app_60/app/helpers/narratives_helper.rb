module NarrativesHelper
  
  def narratives_json(narratives)

    list = narratives.map do |narrative|
      narrative_json(narrative)
    end  
    {:name => "Narratives", :children => list
    }.to_json
  end

  def narrative_json(narrative)
        { :id => " #{narrative.id}",
          :name => narrative.nar_name,
          :picture => narrative.first_image,
          :size => narrative.num_of_view == 0 ? 1 : narrative.num_of_view, # Send back '1' by default
          :language => narrative.language_id,
          :NumberAgree => narrative.num_of_agree,
          :NumberDisagree => narrative.num_of_disagree,
          :NumberViews => narrative.num_of_view,
          :NarrativeID => narrative.id,
          :category => narrative.category_id         
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
    NComment.where(narrative_id: narrative_id)
  end
  
  def get_language_name language_id
    query = "SELECT language_name FROM languages WHERE id = \'#{language_id}\'"
    result = ActiveRecord::Base.connection.execute(query).first;
    if result != nil
      return narrative_language = result["language_name"]
    else
      return nil
    end
  end
  
  def get_category_name category_id
    Category.find(category_id).category_name
  end

end