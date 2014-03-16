require 'test_helper'

class NarrativesHelperTest < ActionView::TestCase
  setup do
    @narratives = Narrative.all
  end
  
  test "narratives_json request should return the expected object structure" do
    result = JSON.parse(narratives_json(@narratives))
    
    strong_assert_valid_keys(result, ['name', 'children'])
    strong_assert_valid_keys(result['children'][0], ['id', 'name', 'language', 'numberAgree', 'numberDisagree', 'numberViews', 'numberComments', 'narrativeID', 'category', 'uploadTime'])
  end
  
  test "sunburst_json request should return the expected object structure" do
    result = JSON.parse(sunburst_json(@narratives))
    
    strong_assert_valid_keys(result, ['name', 'children'])
    strong_assert_valid_keys(result['children'][0], ['category_id', 'count'])
  end

  test "get_language_name should give the expected name" do
    language = Language.new(language_name: "foobar")
    language.save
    assert_equal("foobar", get_language_name(language.id))
    language.destroy
  end

  test "get_category_name should give the expected name" do
    category = Category.new(category_name: "foobar")
    category.save
    assert_equal("foobar", get_category_name(category.id))
    category.destroy
  end
  
  private
    def strong_assert_valid_keys hash, array_of_keys 
      assert hash.assert_valid_keys(array_of_keys)
      assert hash.length == array_of_keys.length, "Incorrect object structure"
    end
    
end
