require 'test_helper'

class RoomObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
		@room = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking)
	end

	test "room price and service_tax is aggregated into booking" do
		assert_equal 22400, @sangla_booking.price_for_rooms
		assert_equal 372, @sangla_booking.service_tax
	end

	test "changes to guest details updates booking" do
		@room.update_attributes(:number_of_children_between_5_and_12_years => 1)
		assert_equal 27200, @sangla_booking.reload.price_for_rooms
	end

	test "changes to number_of_rooms updates booking" do
		@room.update_attributes(:number_of_rooms => 2)
		assert_equal 44800, @sangla_booking.reload.price_for_rooms
		assert_equal 744, @sangla_booking.service_tax
	end

	test "adding new room rows updates booking" do
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking,
						:occupancy => "Single",
						:number_of_adults => 1)
		assert_equal 41200, @sangla_booking.reload.price_for_rooms
		assert_equal 744, @sangla_booking.service_tax
	end

	test "deleting room rows updates booking" do
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking,
						:occupancy => "Single",
						:number_of_adults => 1)
		@room.destroy
		assert_equal 18800, @sangla_booking.reload.price_for_rooms
		assert_equal 372, @sangla_booking.service_tax
	end
end
