require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test "UT-AC-3: Should not be able to upload without including a file" do
    post :upload
    assert_response :redirect
    assert_redirected_to admin_list_path
  end

  test "UT-AC-4: Should not be able to upload a non-zip file" do
    file = fixture_file_upload('files/how-to.pdf', 'application/pdf')
    post :upload, :narrative => file 
    assert_response :redirect
    assert_redirected_to admin_list_path
  end
  
  test "UT-AC-5: Should be able to upload a zip file containing a single narrative" do
    test_narrative_path = Rails.root.join('public', 'narratives', 'narratives_test_single')
    file = fixture_file_upload('files/single_narrative.zip', 'application/zip')
    post :upload, :narrative => file, :upload_path => test_narrative_path
    assert_response :redirect
    assert_redirected_to admin_list_path
    # Remove the directory of the uploaded narrative
    FileUtils.rm_rf(test_narrative_path)
    assert !Dir.exist?(test_narrative_path)
  end
  
  test "UT-AC-6: Should be able to upload a zip file containing multiple narratives" do
    test_narrative_path = Rails.root.join('public', 'narratives', 'narratives_test_multiple')
    file = fixture_file_upload('files/multiple_narratives.zip', 'application/octet-stream')
    post :upload, :narrative => file, :upload_path => test_narrative_path
    assert_response :redirect
    assert_redirected_to admin_list_path
    # Remove the directory of the uploaded narrative
    FileUtils.rm_rf("#{test_narrative_path}")  
    assert !Dir.exist?(test_narrative_path)
  end
  
end