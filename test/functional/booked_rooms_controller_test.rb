require 'test_helper'

class BookedRoomsControllerTest < ActionController::TestCase
  setup do
    @booked_room = booked_rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:booked_rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create booked_room" do
    assert_difference('BookedRoom.count') do
      post :create, booked_room: @booked_room.attributes
    end

    assert_redirected_to booked_room_path(assigns(:booked_room))
  end

  test "should show booked_room" do
    get :show, id: @booked_room.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @booked_room.to_param
    assert_response :success
  end

  test "should update booked_room" do
    put :update, id: @booked_room.to_param, booked_room: @booked_room.attributes
    assert_redirected_to booked_room_path(assigns(:booked_room))
  end

  test "should destroy booked_room" do
    assert_difference('BookedRoom.count', -1) do
      delete :destroy, id: @booked_room.to_param
    end

    assert_redirected_to booked_rooms_path
  end
end
