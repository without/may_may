require 'test_helper'

class MayMaysControllerTest < ActionController::TestCase
  test "all may index" do
    get :index, params: { user: :guest }
    assert_response :success
  end

  test "standard may call new but no edit link returned" do
    get :new, params: { user: :standard }
    assert_response :success
    assert_equal '', response.body
  end

  test "guest may show" do
    get :show, params: { :id => 1, user: :guest }
    assert_response :success
  end

  test "standard may show" do
    get :show, params: { :id => 1, user: :standard }
    assert_response :success
  end

  test "admin may not show" do
    get :show, params: { :id => 1, user: :admin }
    assert_response 401
  end

  test "new includes edit link for admin only" do
    get :new, params: { user: :admin }
    assert_response :success
    assert_equal 'Edit link', response.body.strip
  end

  test "standard cannot destroy" do
    delete :destroy, params: { :id => 1, user: :standard }
    assert_response 401
  end

  test "admin may destroy" do
    delete :destroy, params: { :id => 1, user: :admin }
  end

  test "guest may not create" do
    post :create, params: { user: :guest }
    assert_response 401
  end

  test "admin may create" do
    post :create, params: { user: :admin }
    assert_response :success
  end

  test "admin may get extra" do
    get :extra, params: { :id => 1, :user => :admin }
    assert_response :success
  end

  test "standard may not get extra" do
    get :extra, params: { :id => 1, :user => :standard }
    assert_response 401
  end
end
