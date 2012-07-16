require 'test_helper'

class VasBookingTest < ActiveSupport::TestCase
	test "total price is correctly calculated" do
		vas_booking = FactoryGirl.create(:vas_booking_for_trip,
										:unit_price => 1000,
										:number_of_units => 2)
		assert_equal 2000, vas_booking.total_price
	end
end
