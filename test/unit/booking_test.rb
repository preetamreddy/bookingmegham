require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test 'booking details can not be empty' do 
		booking = Booking.new
		assert booking.invalid?
		assert booking.errors[:guest_name].any?
		assert booking.errors[:guest_phone_number].any?
		assert booking.errors[:number_of_rooms].any?
		assert booking.errors[:from].any?
		assert booking.errors[:to].any?
		assert booking.errors[:number_of_adults].any?
		assert booking.errors[:number_of_children].any?
		assert booking.errors[:number_of_infants].any?
		assert booking.errors[:total_price].any?
		assert booking.errors[:paid].any?
		assert booking.errors[:balance_payment].any?
		assert booking.errors[:pay_by_date].any?
  end

	def new_booking(guest_phone_number, number_of_children)
		booking = Booking.new(guest_name: "Preetam Reddy",
			guest_phone_number: guest_phone_number,
			number_of_rooms: 1,
			from: "2011-12-26",
			to: "2011-12-31",
			number_of_adults: 1,
			number_of_children: number_of_children,
			number_of_infants: 0,
			total_price: 40000,
			paid: 20000,
			balance_payment: 20000,
			pay_by_date: "2011-12-25")
	end

	test 'Guest phone number should be a number greater than 0' do
		good = %w{99 1234 9886833500 08025843149 0013123997278 1}
		no_good = %w{"a" -1 99.9 0 "a9" ""}
		good.each do |guest_phone_number|
			assert new_booking(guest_phone_number, 0).valid?, 
				"#{guest_phone_number} should be valid"
		end
		no_good.each do |guest_phone_number|
			assert new_booking(guest_phone_number, 0).invalid?, 
				"#{guest_phone_number} should not be valid"
		end
	end

	test 'Number of children should be a positive number or 0' do
		good = %w{0 1 2 3 4}
		no_good = %w{-1 "a" 1.2 ""}
		good.each do |number_of_children|
			assert new_booking(99, number_of_children).valid?, 
				"#{number_of_children} should be valid"
		end
		no_good.each do |number_of_children|
			assert new_booking(99, number_of_children).invalid?, 
				"#{number_of_children} should not be valid"
		end
	end
end
