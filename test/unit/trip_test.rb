require 'test_helper'

class TripTest < ActiveSupport::TestCase
	setup do
		@preetam_id = guests(:preetam).id
		@naren_id = guests(:naren).id
	end

  test "trip should belong to a valid guest" do
		himachal_trip = Trip.new(guest_id: 42,
											name: "Himachal trip",
											number_of_rooms: 1,
											number_of_adults: 2,
											start_date: 2012-06-01,
											end_date: 20120-06-05)
		assert !himachal_trip.save
		himachal_trip.guest_id = @preetam_id
		assert himachal_trip.save
  end

	test "trip cannot be destroyed if it has bookings" do
		preetam_trip = trips(:preetam_trip)
		assert !preetam_trip.destroy
	end

	test "trip details can not be empty" do
		himachal_trip = Trip.new
		assert himachal_trip.invalid?
		assert himachal_trip.errors[:guest_id].any?
		assert himachal_trip.errors[:name].any?
		assert himachal_trip.errors[:number_of_rooms].any?
		assert himachal_trip.errors[:number_of_adults].any?
		assert himachal_trip.errors[:start_date].any?
		assert himachal_trip.errors[:end_date].any?
	end

	test "number of adults and rooms should have a value greater than 0" do
		himachal_trip = Trip.new(guest_id: @preetam_id,
											name: "Himachal Trip",
											number_of_rooms: 1.5,
											number_of_adults: "two",
											start_date: 2012-06-01,
											end_date: 2012-06-05)
		assert himachal_trip.invalid?
		assert himachal_trip.errors[:number_of_rooms].any?
		assert himachal_trip.errors[:number_of_adults].any?
		himachal_trip.number_of_rooms = -1
		himachal_trip.number_of_adults = 0
		assert himachal_trip.invalid?
		assert himachal_trip.errors[:number_of_rooms].any?
		assert himachal_trip.errors[:number_of_adults].any?
		himachal_trip.number_of_rooms = 1
		himachal_trip.number_of_adults = 2
		assert himachal_trip.valid?
	end

	test "non adults should be greater than or equal to 0" do
		himachal_trip = Trip.new(guest_id: @naren_id,
											name: "Himachal Trip",
											number_of_rooms: 1,
											number_of_adults: 2,
											start_date: 2012-06-01,
											end_date: 2012-06-05,
											number_of_children_between_5_and_12_years: -1,
											number_of_children_below_5_years: "none")
		assert himachal_trip.invalid?
		assert himachal_trip.errors[:number_of_children_between_5_and_12_years].any?
		assert himachal_trip.errors[:number_of_children_below_5_years].any?
		himachal_trip.number_of_children_between_5_and_12_years = nil
		himachal_trip.number_of_children_below_5_years = 0
		assert himachal_trip.valid?
	end

	test "total price computation" do
		himachal_trip = Trip.create(guest_id: @naren_id,
											name: "Himachal Trip",
											number_of_rooms: 1,
											number_of_adults: 2,
											start_date: 2012-06-01,
											end_date: 2012-06-05)
		assert_equal himachal_trip.total_price, nil
		assert_equal himachal_trip.compute_total_price, nil
		sangla_super_deluxe_tent = room_types(:sangla_super_deluxe_tent)
		himachal_booking_1 = himachal_trip.bookings.build(
			room_type_id: sangla_super_deluxe_tent,
			number_of_rooms: 1,
			number_of_adults: 2,
			check_in_date: 2012-06-01,
			check_out_date: 2012-06-05,
			total_price: 28000)
		himachal_booking_1.save
		assert_equal himachal_trip.compute_total_price, 28000
		himachal_booking_2 = himachal_trip.bookings.build(
			room_type_id: sangla_super_deluxe_tent,
			number_of_rooms: 1,
			number_of_adults: 2,
			check_in_date: 2012-06-01,
			check_out_date: 2012-06-05,
			total_price: 28000)
		himachal_booking_2.save
		assert_equal himachal_trip.compute_total_price, 56000
	end
end
