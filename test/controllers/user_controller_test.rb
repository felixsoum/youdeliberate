require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "Should have a route to access users' index" do
    get :index
    assert_response :success
  end

end
