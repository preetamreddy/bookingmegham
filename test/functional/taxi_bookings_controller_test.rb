require 'test_helper'

class TaxiBookingsControllerTest < ActionController::TestCase
  setup do
    @taxi_booking = taxi_bookings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taxi_bookings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taxi_booking" do
    assert_difference('TaxiBooking.count') do
      post :create, taxi_booking: @taxi_booking.attributes
    end

    assert_redirected_to taxi_booking_path(assigns(:taxi_booking))
  end

  test "should show taxi_booking" do
    get :show, id: @taxi_booking.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taxi_booking.to_param
    assert_response :success
  end

  test "should update taxi_booking" do
    put :update, id: @taxi_booking.to_param, taxi_booking: @taxi_booking.attributes
    assert_redirected_to taxi_booking_path(assigns(:taxi_booking))
  end

  test "should destroy taxi_booking" do
    assert_difference('TaxiBooking.count', -1) do
      delete :destroy, id: @taxi_booking.to_param
    end

    assert_redirected_to taxi_bookings_path
  end
end
