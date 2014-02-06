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

  test "should post upload without zip file" do
    post :upload
    assert_response :success
  end

  test "should post upload with zip file" do
    file = fixture_file_upload('files/1.zip', 'application/zip')
    post :upload, :narrative => file 
    assert_response :success
  end
  
end
