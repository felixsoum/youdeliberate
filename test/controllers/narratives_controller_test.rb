require 'test_helper'

class NarrativesControllerTest < ActionController::TestCase
  setup do
    @narrative = narratives(:one)
    cookies[:user_id] = Admin.take.id
  end

  test "Accessing Admin Portal should successfully reach the portal's index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:narratives)
  end

  test "Admin Portal should have a form to upload" do
    get :index
    assert_select "form"
  end

  test "Narrative should get sunburst" do
    get :sunburst, :format => :json
    assert_response :success
    assert_not_nil assigns(:narratives)
  end

  test "Should have a route to create a new narrative" do
    get :new
    assert_response :success
  end

  test "Narrative creation should save a new narrative in its database table and redirect to the narrative's page" do
    assert_difference('Narrative.count') do
      post :create, narrative: { category_id: @narrative.category_id, create_time: @narrative.create_time, first_image: @narrative.first_image, language_id: @narrative.language_id, nar_name: @narrative.nar_name, nar_path: @narrative.nar_path, num_of_agree: @narrative.num_of_agree, num_of_disagree: @narrative.num_of_disagree, num_of_flagged: @narrative.num_of_flagged, num_of_view: @narrative.num_of_view }
    end

    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "Should have a route to see a single narrative by id" do
    get :show, id: @narrative
    assert_response :success
  end

  test "Should create comment for specified narrative" do
    assert_difference('NComment.where(narrative_id: @narrative.id).count') do
      post :comment, :format => 'js', id: @narrative.id, user_submitted_comment:  "I hate you and your goddamned opinion!"
    end
  end
  
  test "Should have a route to edit a narrative" do
    get :edit, id: @narrative
    assert_response :success
  end
  
  test "Should have a route to play a specific narrative" do
    get :play, id: @narrative
    assert_response :success
  end

  test "Should be able to update a narrative" do
    patch :update, id: @narrative, narrative: { category_id: @narrative.category_id, create_time: @narrative.create_time, first_image: @narrative.first_image, language_id: @narrative.language_id, nar_name: @narrative.nar_name, nar_path: @narrative.nar_path, num_of_agree: @narrative.num_of_agree, num_of_disagree: @narrative.num_of_disagree, num_of_flagged: @narrative.num_of_flagged, num_of_view: @narrative.num_of_view }
    assert_redirected_to admin_list_path
  end

  test "Should be able to destroy narrative" do
    assert_difference('Narrative.count', -1) do
      delete :destroy, id: @narrative
    end

    assert_redirected_to admin_list_path
  end
  
  test "Should not be able to use the create narrative action" do
    assert_no_difference('Narrative.count') do
      post :create, narrative: {category_id: @narrative.category_id}
    end

    assert_template :new
  end
  
  test "Agreeing with a narrative should increment num_of_agree" do
    assert_difference("Narrative.find(@narrative.id).num_of_agree", 1) do
      post :agree, id: @narrative.id, :format => :json
    end
  end
  
  test "Disagreeing with a narrative should increment num_of_disagree" do
    assert_difference("Narrative.find(@narrative.id).num_of_disagree", 1) do
      post :disagree, id: @narrative.id, :format => :json
    end
  end
  
  test "Undoing agreement with a narrative should decrement num_of_agree" do
    assert_difference("Narrative.find(@narrative.id).num_of_agree", -1) do
      post :undo_agree, id: @narrative.id, :format => :json
    end
  end
  
  test "Undoing disagreement with a narrative should decrement num_of_disagree" do
    assert_difference("Narrative.find(@narrative.id).num_of_disagree", -1) do
      post :undo_disagree, id: @narrative.id, :format => :json
    end
  end

end
