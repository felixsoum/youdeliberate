require 'test_helper'

class AdminFlowsTest < ActionDispatch::IntegrationTest

  test "IT-AF-1: Login with valid email and password and browse site" do
    https!
    get "/admin/login"
    assert_response :success

    post_via_redirect "/sessions", :session => {email: admins(:one).user_name, password: "soen390"}
    assert_equal '/admin', path

    https!
    get "/admin"
    assert_response :success
  end

  test "IT-AF-2: Should not login with invalid email or password" do
    https!
    get "/admin/login"
    assert_response :success

    post_via_redirect "/sessions", :session => {email: admins(:one).user_name, password: "soen"}
    assert_equal '/sessions', path
    assert_equal 'Invalid email/password combination', flash[:error]
  end

  test "IT-AF-3: Upload and manage narratives" do
    post_via_redirect "/sessions", :session => {email: admins(:one).user_name, password: "soen390"}

    https!
    get "/admin"

    test_narrative_path = Rails.root.join('public', 'narratives', 'narratives_test_single')
    file = fixture_file_upload('test/fixtures/files/single_narrative.zip', 'application/zip')
    post_via_redirect "/admin/upload", :narrative => file, :upload_path => test_narrative_path
    assert_equal '/admin', path

    changed_narratives = {Narrative.last!.id=>{"nar_name"=>"100", "language_id"=>"1", "category_id"=>"1", "is_published"=>"t"}, 
                          "298486374"=>{"nar_name"=>"100", "language_id"=>"1", "category_id"=>"1", "is_published"=>"t"}, 
                          "980190962"=>{"nar_name"=>"200", "language_id"=>"1", "category_id"=>"2", "is_published"=>"t"}} 
    post_via_redirect "narratives/save", :narrative_attributes => changed_narratives
    assert_equal '/admin', path

    FileUtils.rm_rf(test_narrative_path)
    assert !Dir.exist?(test_narrative_path)
  end

end
