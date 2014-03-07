require 'test_helper'

class NarrativesHelperTest < ActionView::TestCase
  setup do
    @narratives = Narrative.all
  end
  
  test "narratives_json request should return the expected object structure" do
    result = JSON.parse(narratives_json(@narratives))
    assert result.assert_valid_keys('name', 'children')
    assert result['children'][0].assert_valid_keys('id', 'name', 'picture', 'size', 'language', 'NumberAgree', 'NumberDisagree', 'NumberViews', 'NarrativeID', 'category')
  end
  
  test "sunburst_json request should return the expected object structure" do
    narratives = Narrative.all
    result = JSON.parse(sunburst_json(narratives))
    assert result.assert_valid_keys('name', 'children')
    assert result['children'][0].assert_valid_keys('category_id', 'count')
  end
    
end
