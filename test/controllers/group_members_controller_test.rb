require 'test_helper'

class GroupMembersControllerTest < ActionController::TestCase
  test "should get join" do
    get :join
    assert_response :success
  end

  test "should get leave" do
    get :leave
    assert_response :success
  end

end
