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

  test "UT-AC-7: Should be able to change password" do
    cookies[:user_id] = Admin.first!.id
    post :change_password, :password => "change", :password_confirmation => "change"
    assert_equal 'Your password has been changed.', flash[:success]
    assert_response :redirect
    assert_redirected_to admin_setting_path
  end

  test "UT-AC-8: Should not be able to change password when password and password confimation are different" do
    cookies[:user_id] = Admin.first!.id
    post :change_password, :password => "change", :password_confirmation => "notchange"
    assert_equal 'Please make sure the passwords you typed are the same.', flash[:error]
    assert_response :redirect
    assert_redirected_to admin_setting_path
  end

  test "UT-AC-9: Should be able to add another admin account with valid information" do
    post :add_admin, :email => "add@new.com", :password => "addnew", :password_confirmation => "addnew"
    assert_equal 'The new administrator has been added successfully.', flash[:success]
    assert_response :redirect
    assert_redirected_to admin_setting_path
  end

  test "UT-AC-10: Should not be able to add another admin account with invalid information" do
    post :add_admin, :email => "add@new.com", :password => "addnew", :password_confirmation => "addothernew"
    assert_equal 'The administrator is not added.', flash[:error]
    assert_response :redirect
    assert_redirected_to admin_setting_path
  end

end