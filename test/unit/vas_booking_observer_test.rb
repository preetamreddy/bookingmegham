require 'test_helper'

class VasBookingObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@trip_vas = FactoryGirl.create(:vas_booking_for_trip,
									:trip => @himachal_trip,
									:unit_price => 700)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
		@booking_vas = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 300)
	end

	test "trip vas price is aggregated into trip" do
		assert_equal 700, @himachal_trip.reload.price_for_vas
	end

	test "booking vas price is aggregated into booking" do
		assert_equal 300, @sangla_booking.reload.price_for_vas
	end

	test "changes to trip vas details updates trip" do
		@trip_vas.update_attributes(:number_of_units => 2)
		assert_equal 1400, @himachal_trip.reload.price_for_vas
		@trip_vas.update_attributes(:unit_price => 800)
		assert_equal 1600, @himachal_trip.reload.price_for_vas
	end

	test "adding new trip vas updates trip" do
		@trip_vas_2 = FactoryGirl.create(:vas_booking_for_trip,
										:trip => @himachal_trip,
										:unit_price => 600)
		assert_equal 1300, @himachal_trip.reload.price_for_vas
	end

	test "deleting trip vas row updates trip" do
		@trip_vas_2 = FactoryGirl.create(:vas_booking_for_trip,
										:trip => @himachal_trip,
										:unit_price => 600)
		@trip_vas.destroy
		assert_equal 600, @himachal_trip.reload.price_for_vas
	end

	test "changes to booking vas details updates booking" do
		@booking_vas.update_attributes(:number_of_units => 3)
		assert_equal 900, @sangla_booking.reload.price_for_vas
		@booking_vas.update_attributes(:unit_price => 200)
		assert_equal 600, @sangla_booking.reload.price_for_vas
	end

	test "adding new booking vas updates booking" do
		@booking_vas_2 = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 400)
		assert_equal 700, @sangla_booking.reload.price_for_vas
	end

	test "deleting booking vas row updates booking" do
		@booking_vas_2 = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 400)
		@booking_vas.destroy
		assert_equal 400, @sangla_booking.reload.price_for_vas
	end
end
