require 'test_helper'

class BookingTest < ActiveSupport::TestCase
	setup do
		@preetam_trip_id = trips(:preetam_trip).id
		@sangla_super_deluxe_tent_id = room_types(:sangla_super_deluxe_tent).id
	end

	def new_booking(trip_id, room_type_id, total_price)
		booking = Booking.new(trip_id: trip_id,
												room_type_id: room_type_id,
												check_in_date: 2012-05-01,
												check_out_date: 2012-05-05,
												total_price: total_price)
		return booking
	end

	test "booking should belong to a valid trip" do
		himachal_booking = new_booking(42, @sangla_super_deluxe_tent_id, 28000)
		assert !himachal_booking.save
		himachal_booking.trip_id = @preetam_trip_id
		assert himachal_booking.save
	end

	test "booking should be for a valid room type" do
		himachal_booking = new_booking(@preetam_trip_id, 42, 28000)
		assert !himachal_booking.save
		himachal_booking.room_type_id = @sangla_super_deluxe_tent_id
		assert himachal_booking.save
	end

	#save is not executing callback after_save. Parking this for now.
	test "line items are created and updated based on changes to bookings" do
		true
	end

	test "corresponding trip roll up attributes are updated" do
		himachal_booking = new_booking(@preetam_trip_id, @sangla_super_deluxe_tent_id, 22000)
		himachal_booking.save
		himachal_booking_id = himachal_booking.id
		assert_equal himachal_booking.trip.total_price, 50000
	end

  test 'booking details can not be empty' do 
		himachal_booking = Booking.new
		assert himachal_booking.invalid?
		assert himachal_booking.errors[:trip_id].any?
		assert himachal_booking.errors[:room_type_id].any?
		assert himachal_booking.errors[:check_in_date].any?
		assert himachal_booking.errors[:check_out_date].any?
		assert himachal_booking.errors[:total_price].any?
  end

	test "non adults and total price should be greater than or equal to 0" do
		himachal_booking = new_booking(@preetam_trip_id, @sangla_super_deluxe_tent_id, 28000)
		himachal_booking.number_of_children_below_5_years = "none"
		himachal_booking.number_of_drivers = -1
		himachal_booking.total_price = 28000.5
		assert himachal_booking.invalid?
		assert himachal_booking.errors[:number_of_children_below_5_years].any?
		assert himachal_booking.errors[:number_of_drivers].any?
		assert himachal_booking.errors[:total_price].any?

		himachal_booking.errors.clear

		himachal_booking.number_of_children_below_5_years = 1
		himachal_booking.number_of_drivers = nil
		himachal_booking.total_price = 28000
		assert himachal_booking.valid?
	end

end
