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
    test_narrative_path = Rails.root.join('public', 'narratives', 'narratives_backup')
    file = fixture_file_upload('files/single_narrative.zip', 'application/zip')
    post :upload, :narrative => file, :upload_path => test_narrative_path
    assert_response :success
    # Remove the directory of the uploaded narrative
    FileUtils.rm_rf(test_narrative_path)
    assert !Dir.exist?(test_narrative_path)
  end
  
  test "should post upload with zip file with multiple narratives" do
    test_narrative_path = Rails.root.join('public', 'narratives', 'narratives_test')
    file = fixture_file_upload('files/multiple_narratives.zip', 'application/octet-stream')
    post :upload, :narrative => file, :upload_path => test_narrative_path
    assert_response :success
    # Remove the directory of the uploaded narrative
    FileUtils.rm_rf("#{test_narrative_path}")  
    assert !Dir.exist?(test_narrative_path)
  end
  
end
