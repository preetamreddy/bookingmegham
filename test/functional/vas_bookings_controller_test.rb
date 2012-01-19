require 'test_helper'

class VasBookingsControllerTest < ActionController::TestCase
  setup do
    @vas_booking = vas_bookings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vas_bookings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vas_booking" do
    assert_difference('VasBooking.count') do
      post :create, vas_booking: @vas_booking.attributes
    end

    assert_redirected_to vas_booking_path(assigns(:vas_booking))
  end

  test "should show vas_booking" do
    get :show, id: @vas_booking.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vas_booking.to_param
    assert_response :success
  end

  test "should update vas_booking" do
    put :update, id: @vas_booking.to_param, vas_booking: @vas_booking.attributes
    assert_redirected_to vas_booking_path(assigns(:vas_booking))
  end

  test "should destroy vas_booking" do
    assert_difference('VasBooking.count', -1) do
      delete :destroy, id: @vas_booking.to_param
    end

    assert_redirected_to vas_bookings_path
  end
end
