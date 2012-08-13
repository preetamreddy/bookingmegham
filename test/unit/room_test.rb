require 'test_helper'

class RoomTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
		@room = FactoryGirl.create(:room,
						:booking => @sangla_booking)
	end

	test "total price is correctly calculated" do
		assert_equal 22400, @room.total_price
	end

	test "service tax calculation" do
		assert_equal 93, @room.service_tax_per_room_night
		assert_equal 372, @room.service_tax
	end
end
