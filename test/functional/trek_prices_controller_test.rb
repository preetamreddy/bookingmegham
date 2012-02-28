require 'test_helper'

class TrekPricesControllerTest < ActionController::TestCase
  setup do
    @trek_price = trek_prices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trek_prices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trek_price" do
    assert_difference('TrekPrice.count') do
      post :create, trek_price: @trek_price.attributes
    end

    assert_redirected_to trek_price_path(assigns(:trek_price))
  end

  test "should show trek_price" do
    get :show, id: @trek_price.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trek_price.to_param
    assert_response :success
  end

  test "should update trek_price" do
    put :update, id: @trek_price.to_param, trek_price: @trek_price.attributes
    assert_redirected_to trek_price_path(assigns(:trek_price))
  end

  test "should destroy trek_price" do
    assert_difference('TrekPrice.count', -1) do
      delete :destroy, id: @trek_price.to_param
    end

    assert_redirected_to trek_prices_path
  end
end
