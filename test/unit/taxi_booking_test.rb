require 'test_helper'

class TaxiBookingTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
	end

	test "total price is correctly calculated" do
		taxi_booking = FactoryGirl.create(:taxi_booking,
										:trip => @himachal_trip)
		assert_equal 35000, taxi_booking.total_price
	end
end
