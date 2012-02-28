require 'test_helper'

class TrekBookingsControllerTest < ActionController::TestCase
  setup do
    @trek_booking = trek_bookings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trek_bookings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trek_booking" do
    assert_difference('TrekBooking.count') do
      post :create, trek_booking: @trek_booking.attributes
    end

    assert_redirected_to trek_booking_path(assigns(:trek_booking))
  end

  test "should show trek_booking" do
    get :show, id: @trek_booking.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trek_booking.to_param
    assert_response :success
  end

  test "should update trek_booking" do
    put :update, id: @trek_booking.to_param, trek_booking: @trek_booking.attributes
    assert_redirected_to trek_booking_path(assigns(:trek_booking))
  end

  test "should destroy trek_booking" do
    assert_difference('TrekBooking.count', -1) do
      delete :destroy, id: @trek_booking.to_param
    end

    assert_redirected_to trek_bookings_path
  end
end
