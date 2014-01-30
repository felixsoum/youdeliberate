require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index view should have form to upload" do
  	get :index
  	assert_select "form"
  end

  test "should post upload" do
    post :upload
    assert_response :success
  end

end
