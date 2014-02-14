module NarrativesHelper
  
  def narratives_json(narratives)

      list = narratives.map do |narrative|
        narrative_json(narrative)
      end  
      # Is this level structure really pertinent?
      {:name => "flare", :children =>  
        [{
          :name => "analytics", :children =>  
          [{
            :name => "Against", :children => list
          }]
        }]
      }.to_json
    end
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
          #:category => "ForDisagreed"          
        }
  end

