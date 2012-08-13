require 'test_helper'

class BookingObserverTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
		@room = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking)
		@booking_vas = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 300)
	end

	test "room price and service_tax is aggregated into trip" do
		assert_equal 22700, @himachal_trip.price_for_rooms
		assert_equal 372, @himachal_trip.service_tax
	end

	test "changes to guest details updates trip" do
		@room.update_attributes(:number_of_children_between_5_and_12_years => 1)
		assert_equal 27500, @himachal_trip.reload.price_for_rooms
		assert_equal 372, @himachal_trip.service_tax
	end

	test "changes to number_of_rooms updates trip" do
		@room.update_attributes(:number_of_rooms => 2)
		assert_equal 45100, @himachal_trip.reload.price_for_rooms
		assert_equal 744, @himachal_trip.service_tax
	end

	test "adding new room rows updates trip" do
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking,
						:occupancy => "Single",
						:number_of_adults => 1)
		assert_equal 41500, @himachal_trip.reload.price_for_rooms
		assert_equal 744, @himachal_trip.service_tax
	end

	test "deleting room rows updates trip" do
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => @sangla_booking,
						:occupancy => "Single",
						:number_of_adults => 1)
		@room.destroy
		assert_equal 19100, @himachal_trip.reload.price_for_rooms
		assert_equal 372, @himachal_trip.service_tax
	end

	test "changes to booking vas details updates trip" do
		@booking_vas.update_attributes(:number_of_units => 3)
		assert_equal 23300, @himachal_trip.reload.price_for_rooms
		@booking_vas.update_attributes(:unit_price => 200)
		assert_equal 23000, @himachal_trip.reload.price_for_rooms
	end

	test "adding new booking vas updates booking" do
		@booking_vas_2 = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 400)
		assert_equal 23100, @himachal_trip.reload.price_for_rooms
	end

	test "deleting booking vas row updates booking" do
		@booking_vas_2 = FactoryGirl.create(:vas_booking_for_booking,
										:booking => @sangla_booking,
										:unit_price => 400)
		@booking_vas.destroy
		assert_equal 22800, @himachal_trip.reload.price_for_rooms
	end

	test "adding new bookings updates trips" do
		booking_2 = FactoryGirl.create(:booking,
									:trip => @himachal_trip)
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => booking_2,
						:number_of_rooms => 2)
		assert_equal 67500, @himachal_trip.reload.price_for_rooms
		assert_equal 1116, @himachal_trip.service_tax
	end

	test "updating bookings updates trips" do
		booking_2 = FactoryGirl.create(:booking,
									:trip => @himachal_trip)
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => booking_2,
						:number_of_rooms => 2)
		@room.update_attributes(:number_of_adults => 3)
		assert_equal 75500, @himachal_trip.reload.price_for_rooms
		assert_equal 1116, @himachal_trip.service_tax
	end

	test "deleting booking updates trips" do
		booking_2 = FactoryGirl.create(:booking,
									:trip => @himachal_trip)
		room_2 = FactoryGirl.create(:room_for_booking,
						:booking => booking_2,
						:number_of_rooms => 2)
		@room.destroy
		@booking_vas.destroy
		@sangla_booking.reload.destroy
		assert_equal 44800, @himachal_trip.reload.price_for_rooms
		assert_equal 744, @himachal_trip.service_tax
	end
end
