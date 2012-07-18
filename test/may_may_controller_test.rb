require 'test_helper'

class MayMayControllerTest < ActionController::TestCase
  test "permission denied without role setup" do
    get :index
    assert_response 403
  end

  test "success but no body with only index role defined" do
    get :index, :roles => [:index_role]
    assert_response :success
    assert_equal '', response.body
  end

  test "edit link body with index, edit roles defined" do
    get :index, :roles => [:index_role, :edit_role]
    assert_response :success
    assert_equal 'Edit link', response.body.strip
  end
end
