require 'test_helper'

class ValueAddedServicesControllerTest < ActionController::TestCase
  setup do
    @value_added_service = value_added_services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:value_added_services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create value_added_service" do
    assert_difference('ValueAddedService.count') do
      post :create, value_added_service: @value_added_service.attributes
    end

    assert_redirected_to value_added_service_path(assigns(:value_added_service))
  end

  test "should show value_added_service" do
    get :show, id: @value_added_service.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @value_added_service.to_param
    assert_response :success
  end

  test "should update value_added_service" do
    put :update, id: @value_added_service.to_param, value_added_service: @value_added_service.attributes
    assert_redirected_to value_added_service_path(assigns(:value_added_service))
  end

  test "should destroy value_added_service" do
    assert_difference('ValueAddedService.count', -1) do
      delete :destroy, id: @value_added_service.to_param
    end

    assert_redirected_to value_added_services_path
  end
end
