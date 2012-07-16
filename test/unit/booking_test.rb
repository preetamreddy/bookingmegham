require 'test_helper'

class BookingTest < ActiveSupport::TestCase
	setup do
		@preetam = FactoryGirl.create(:guest,
										:name => "Preetam Reddy")
		@himachal_trip = FactoryGirl.create(:trip,
											:guest => @preetam)
		@sangla_booking = FactoryGirl.create(:booking,
												:trip => @himachal_trip)
	end

	test "price for vas rolls up from vas bookings - single vas" do
		rappelling = FactoryGirl.create(:vas_booking_for_booking,
			:value_added_service => "Rappelling",
			:unit_price => 500,
			:number_of_units => 1,
			:booking => @sangla_booking)
		assert_equal 500, @sangla_booking.price_for_vas
	end

	test "price for vas rolls up from vas bookings - multiple vas" do
		rappelling = FactoryGirl.create(:vas_booking_for_booking,
			:value_added_service => "Rappelling",
			:unit_price => 500,
			:number_of_units => 1,
			:booking => @sangla_booking)
		river_crossing = FactoryGirl.create(:vas_booking_for_booking,
			:value_added_service => "River crossing",
			:unit_price => 500,
			:number_of_units => 2,
			:booking => @sangla_booking)
		assert_equal 1500, @sangla_booking.price_for_vas
	end

#	test "booking should belong to a valid trip" do
#		a_booking = FactoryGirl.build(:booking,
#									:trip => nil)	
#		assert !a_booking.save
#		a_booking.trip_id = @a_trip.id
#		assert a_booking.save
#	end
#
#	test "booking should be for a valid room type" do
#		a_booking = FactoryGirl.build(:booking,
#									:room_type => nil)
#		assert !a_booking.save
#		a_booking.room_type_id = @a_room_type.id
#		assert a_booking.save
#	end

	#save is not executing callback after_save. Parking this for now.
#	test "line items are created and updated based on changes to bookings" do
#		true
#	end

#	test "corresponding trip roll up attributes are updated" do
#		himachal_booking = new_booking(@preetam_trip_id, @sangla_super_deluxe_tent_id, 22000)
#		himachal_booking.save
#		himachal_booking_id = himachal_booking.id
#		assert_equal himachal_booking.trip.total_price, 50000
#	end

#  test 'booking details can not be empty' do 
#		a_booking = FactoryGirl.build(:booking,
#									:check_in_date => nil,
#									:number_of_nights => nil)
#		assert a_booking.invalid?
#		assert a_booking.errors[:check_in_date].any?
#		assert a_booking.errors[:number_of_nights].any?
#		a_booking.check_in_date = Date.today + 30
#		a_booking.number_of_nights = 4
#		assert a_booking.save
#  end

#	test "non adults and total price should be greater than or equal to 0" do
#		himachal_booking = new_booking(@preetam_trip_id, @sangla_super_deluxe_tent_id, 28000)
#		himachal_booking.number_of_children_below_5_years = "none"
#		himachal_booking.number_of_drivers = -1
#		himachal_booking.total_price = 28000.5
#		assert himachal_booking.invalid?
#		assert himachal_booking.errors[:number_of_children_below_5_years].any?
#		assert himachal_booking.errors[:number_of_drivers].any?
#		assert himachal_booking.errors[:total_price].any?
#
#		himachal_booking.errors.clear
#
#		himachal_booking.number_of_children_below_5_years = 1
#		himachal_booking.number_of_drivers = nil
#		himachal_booking.total_price = 28000
#		assert himachal_booking.valid?
#	end
end
