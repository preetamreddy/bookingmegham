require 'test_helper'

class RoomTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
	end

	test "total price is correctly calculated" do
		room = FactoryGirl.create(:room,
						:booking => @sangla_booking)
		assert_equal 22400, room.total_price
	end
end
