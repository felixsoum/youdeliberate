json.array!(@narratives) do |narrative|
  json.extract! narrative, :id, :nar_name, :nar_path, :language_id, :category_id, :first_image, :num_of_view, :num_of_agree, :num_of_disagree, :num_of_flagged, :create_time
  json.url narrative_url(narrative, format: :json)
end
