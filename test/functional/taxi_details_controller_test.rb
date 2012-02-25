require 'test_helper'

class TaxiDetailsControllerTest < ActionController::TestCase
  setup do
    @taxi_detail = taxi_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taxi_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taxi_detail" do
    assert_difference('TaxiDetail.count') do
      post :create, taxi_detail: @taxi_detail.attributes
    end

    assert_redirected_to taxi_detail_path(assigns(:taxi_detail))
  end

  test "should show taxi_detail" do
    get :show, id: @taxi_detail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taxi_detail.to_param
    assert_response :success
  end

  test "should update taxi_detail" do
    put :update, id: @taxi_detail.to_param, taxi_detail: @taxi_detail.attributes
    assert_redirected_to taxi_detail_path(assigns(:taxi_detail))
  end

  test "should destroy taxi_detail" do
    assert_difference('TaxiDetail.count', -1) do
      delete :destroy, id: @taxi_detail.to_param
    end

    assert_redirected_to taxi_details_path
  end
end
