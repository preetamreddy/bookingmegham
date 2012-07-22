require 'test_helper'

class VasBookingTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
	end
	test "total price for single day trip vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_trip,
										:trip => @himachal_trip)
		assert_equal 1000, vas_booking.total_price
	end

	test "total price for single day booking vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking)
		assert_equal 1000, vas_booking.total_price
	end

	test "total price for all days trip vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_trip,
										:trip => @himachal_trip,
										:unit_price => 500,
										:number_of_units => 2,
										:every_day => 1)
		assert_equal 10000, vas_booking.total_price
	end

	test "total price for all days booking vas" do
		vas_booking = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 800,
										:number_of_units => 2,
										:every_day => 1)
		assert_equal 6400, vas_booking.total_price
	end
end
