require 'test_helper'

class MayMaysControllerTest < ActionController::TestCase
  test "all may index" do
    get :index, user: :guest
    assert_response :success
  end

  test "standard may call new but no edit link returned" do
    get :new, user: :standard
    assert_response :success
    assert_equal '', response.body
  end

  test "guest may show" do
    get :show, :id => 1, user: :guest
    assert_response :success
  end

  test "standard may show" do
    get :show, :id => 1, user: :standard
    assert_response :success
  end

  test "admin may not show" do
    get :show, :id => 1, user: :admin
    assert_response 401
  end

  test "new includes edit link for admin only" do
    get :new, user: :admin
    assert_response :success
    assert_equal 'Edit link', response.body.strip
  end

  test "standard cannot destroy" do
    delete :destroy, :id => 1, user: :standard
    assert_response 401
  end

  test "admin may destroy" do
    delete :destroy, :id => 1, user: :admin
  end

  test "guest may not create" do
    post :create, user: :guest
    assert_response 401
  end

  test "admin may create" do
    post :create, user: :admin
    assert_response :success
  end
end
