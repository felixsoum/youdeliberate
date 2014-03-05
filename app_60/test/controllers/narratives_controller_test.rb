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
        
  test "should create comment for specified narrative" do
    assert_difference('NComment.where(narrative_id: @narrative.id).count') do
      post :comment, id: @narrative.id, comment: "I hate you and your goddamned opinion!"
    end
  end
  
  test "should redirect to single narrative view" do
    post :comment, id: @narrative.id, comment: "I hate you and your goddamned opinion!"
    #assert_redirected_to :controller => "narratives", :action => "play"
    assert_redirected_to narrative_play_path(id: @narrative.id)
  end

  test "should get edit" do
    get :edit, id: @narrative
    assert_response :success
  end
  
  test "should access play action in narrative controller" do
    get :play, id: @narrative
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
