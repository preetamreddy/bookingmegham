require 'test_helper'

class TaxiBookingObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@taxi_booking = FactoryGirl.create(:taxi_booking,
											:trip => @himachal_trip)
	end

	test "taxi_booking price is aggregated into trip" do
		assert_equal 35000, @himachal_trip.reload.price_for_transport
	end

	test "changes to taxi booking details updates trip" do
		@taxi_booking.update_attributes(:number_of_days => 6)
		assert_equal 21000, @himachal_trip.reload.price_for_transport
	end

	test "adding new taxi booking updates trip" do
		taxi_booking_2 = FactoryGirl.create(:taxi_booking,
												:trip => @himachal_trip,
												:number_of_days => 3)
		assert_equal 45500, @himachal_trip.reload.price_for_transport
	end

	test "deleting a taxi booking updates trip" do
		taxi_booking_2 = FactoryGirl.create(:taxi_booking,
												:trip => @himachal_trip,
												:number_of_days => 8)
		
		@taxi_booking.destroy
		assert_equal 28000, @himachal_trip.reload.price_for_transport
	end
end
