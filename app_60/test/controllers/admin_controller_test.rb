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
    assert_template :index
  end

  test "should post upload with non-zip file" do
    file = fixture_file_upload('files/how-to.pdf', 'application/pdf')
    post :upload, :narrative => file 
    assert_response :success
    assert_template :index
  end
  
  test "should post upload with zip file" do
    # Save current narratives
    old_path = Rails.root.join('public', 'narratives')
    new_path = Rails.root.join('public', 'narratives_backup')
    FileUtils.mv(old_path, new_path)

    file = fixture_file_upload('files/1.zip', 'application/zip')
    post :upload, :narrative => file 
    assert_response :success

    # Remove the directory of the uploaded narrative
    FileUtils.rm_rf(old_path)

    # Restore saved narratives
    FileUtils.mv(new_path, old_path)
  end
  
end
