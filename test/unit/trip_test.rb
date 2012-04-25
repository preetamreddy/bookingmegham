require 'test_helper'

class TripTest < ActiveSupport::TestCase
	setup do
		@preetam = FactoryGirl.create(:guest,
										:name => "Preetam Reddy")
	end

#  test "trip should belong to a valid guest" do
#		new_trip = FactoryGirl.build(:trip,
#								:guest => nil)
#		assert !new_trip.save
#		assert new_trip.errors[:guest_id].any?
#		new_trip.guest_id = @preetam.id
#		assert new_trip.save
#  end

#	test "trip cannot be destroyed if it has bookings" do
#		preetam_trip = trips(:preetam_trip)
#		assert !preetam_trip.destroy
#	end

#	test "trip details can not be empty" do
#		a_trip = FactoryGirl.build(:trip,
#							:name => nil,
#							:start_date => nil,
#							:number_of_days => nil)
#		assert a_trip.invalid?
#		assert a_trip.errors[:name].any?
#		assert a_trip.errors[:start_date].any?
#		a_trip.name = "Signature Banjara"
#		a_trip.start_date = Date.today + 30
#		a_trip.number_of_days = 9
#		assert a_trip.save
#	end
#
#	test "non adults should be greater than or equal to 0" do
#		a_trip = FactoryGirl.build(:trip,
#							number_of_children_below_5_years: "none",
#							number_of_drivers: 1.5)
#		assert a_trip.invalid?
#		assert a_trip.errors[:number_of_children_below_5_years].any?
#		assert a_trip.errors[:number_of_drivers].any?
#		a_trip.number_of_children_below_5_years = 1
#		a_trip.number_of_drivers = 0
#		assert a_trip.save
#	end

#	test "total price computation" do
#		himachal_trip = Trip.create(guest_id: @naren_id,
#											name: "Himachal Trip",
#											start_date: 2012-06-01,
#											end_date: 2012-06-05)
#		assert_equal himachal_trip.total_price, 0
#		sangla_super_deluxe_tent = room_types(:sangla_super_deluxe_tent)
#		himachal_booking_1 = himachal_trip.bookings.build(
#			room_type_id: sangla_super_deluxe_tent,
#			check_in_date: 2012-06-01,
#			check_out_date: 2012-06-05,
#			total_price: 28000)
#		himachal_booking_1.save
#		assert_equal himachal_trip.total_price, 28000
#		himachal_booking_2 = himachal_trip.bookings.build(
#			room_type_id: sangla_super_deluxe_tent,
#			check_in_date: 2012-06-01,
#			check_out_date: 2012-06-05,
#			total_price: 28000)
#		himachal_booking_2.save
#		assert_equal himachal_trip.total_price, 56000
#	end
end
