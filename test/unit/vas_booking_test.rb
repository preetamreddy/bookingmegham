require 'test_helper'

class VasBookingTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
	end
	test "total price is correctly calculated for trip vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_trip,
										:trip => @himachal_trip,
										:unit_price => 1000,
										:number_of_units => 2)
		assert_equal 2000, vas_booking.total_price
	end

	test "total price is correctly calculated for booking vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 1000,
										:number_of_units => 2)
		assert_equal 2000, vas_booking.total_price
	end
end
