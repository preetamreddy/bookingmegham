require 'test_helper'

class VasPricesControllerTest < ActionController::TestCase
  setup do
    @vas_price = vas_prices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vas_prices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vas_price" do
    assert_difference('VasPrice.count') do
      post :create, vas_price: @vas_price.attributes
    end

    assert_redirected_to vas_price_path(assigns(:vas_price))
  end

  test "should show vas_price" do
    get :show, id: @vas_price.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vas_price.to_param
    assert_response :success
  end

  test "should update vas_price" do
    put :update, id: @vas_price.to_param, vas_price: @vas_price.attributes
    assert_redirected_to vas_price_path(assigns(:vas_price))
  end

  test "should destroy vas_price" do
    assert_difference('VasPrice.count', -1) do
      delete :destroy, id: @vas_price.to_param
    end

    assert_redirected_to vas_prices_path
  end
end
