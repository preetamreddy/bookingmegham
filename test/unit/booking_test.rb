require 'test_helper'

class BookingTest < ActiveSupport::TestCase
	setup do
		@himachal_trip = FactoryGirl.create(:trip)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
		@vas_booking = FactoryGirl.create(:vas_booking_for_booking,
									:booking => @sangla_booking)
		@room = FactoryGirl.create(:room_for_booking,
							:booking => @sangla_booking)
	end

	test "booking should be for a valid room type" do
		a_booking = FactoryGirl.build(:booking,
									:room_type => nil)
		assert a_booking.invalid?
		super_deluxe_tent = FactoryGirl.create(:room_type)
		a_booking.room_type_id = super_deluxe_tent.id
		assert a_booking.save
	end

	test "booking cannot be deleted when it has rooms" do
		@vas_booking.destroy
		assert !@sangla_booking.reload.destroy
	end

	test "booking cannot be deleted when it has vas bookings" do
		@room.destroy
		assert !@sangla_booking.reload.destroy
	end

	test "price for vas rolls up to bookings" do
		assert_equal 1000, @sangla_booking.reload.price_for_vas
	end

	test "price for rooms rolls up to bookings" do
		assert_equal 22400, @sangla_booking.reload.price_for_rooms
	end

	test "total price in bookings is updated" do
		assert_equal 23400, @sangla_booking.reload.total_price
	end

	test "cancellation charge is total price for cancelled bookings" do
		assert_equal 23400, @sangla_booking.reload.total_price	
		@sangla_booking.update_attributes(:cancelled => 1,
			:cancellation_charge => 11200)
		assert_equal 11200, @sangla_booking.reload.total_price	
	end
end
