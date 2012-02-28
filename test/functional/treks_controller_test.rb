require 'test_helper'

class TreksControllerTest < ActionController::TestCase
  setup do
    @trek = treks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:treks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trek" do
    assert_difference('Trek.count') do
      post :create, trek: @trek.attributes
    end

    assert_redirected_to trek_path(assigns(:trek))
  end

  test "should show trek" do
    get :show, id: @trek.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trek.to_param
    assert_response :success
  end

  test "should update trek" do
    put :update, id: @trek.to_param, trek: @trek.attributes
    assert_redirected_to trek_path(assigns(:trek))
  end

  test "should destroy trek" do
    assert_difference('Trek.count', -1) do
      delete :destroy, id: @trek.to_param
    end

    assert_redirected_to treks_path
  end
end
