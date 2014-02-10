require 'test_helper'

class NarrativesControllerTest < ActionController::TestCase
  setup do
    @narrative = narratives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:narratives)
  end
  
  # This test could also be done in helpers/narratives_helper_test -- but if it passes here, then the helper works.
  test "should have the appropriate JSON object" do
    params = {:format => 'json'}
  
    get :index, params
    
    narratives = JSON.parse(@response.body)
    narrative = narratives['children'][0]['children'][0]['children'][0] # Skip the whole hierarchy and only look at the first narrative object
    assert_not_nil(narrative['id'])
    assert_not_nil(narrative['name'])
    assert_not_nil(narrative['picture'])
    assert_not_nil(narrative['size'])
    assert_not_nil(narrative['language'])
    assert_not_nil(narrative['NumberAgree'])
    assert_not_nil(narrative['NumberDisagree'])
    assert_not_nil(narrative['NumberViews'])
    assert_not_nil(narrative['NarrativeID'])
    assert_not_nil(narrative['category'])
   end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create narrative" do
    assert_difference('Narrative.count') do
      post :create, narrative: { category_id: @narrative.category_id, create_time: @narrative.create_time, first_image: @narrative.first_image, language_id: @narrative.language_id, nar_name: @narrative.nar_name, nar_path: @narrative.nar_path, num_of_agree: @narrative.num_of_agree, num_of_disagree: @narrative.num_of_disagree, num_of_flagged: @narrative.num_of_flagged, num_of_view: @narrative.num_of_view }
    end

    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should show narrative" do
    get :show, id: @narrative
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @narrative
    assert_response :success
  end

  test "should update narrative" do
    patch :update, id: @narrative, narrative: { category_id: @narrative.category_id, create_time: @narrative.create_time, first_image: @narrative.first_image, language_id: @narrative.language_id, nar_name: @narrative.nar_name, nar_path: @narrative.nar_path, num_of_agree: @narrative.num_of_agree, num_of_disagree: @narrative.num_of_disagree, num_of_flagged: @narrative.num_of_flagged, num_of_view: @narrative.num_of_view }
    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should destroy narrative" do
    assert_difference('Narrative.count', -1) do
      delete :destroy, id: @narrative
    end

    assert_redirected_to narratives_path
  end
  
  test "should not create narrative" do
    assert_no_difference('Narrative.count') do
      post :create, narrative: {category_id: @narrative.category_id}
    end

    assert_template :new
  end

end
