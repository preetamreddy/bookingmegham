class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking

	validates :unit_price, :number_of_units, presence: true

	before_save :update_total_price

	before_create :set_account_id

	private

		def number_of_days
			if trip_id
				trip.number_of_days
			elsif booking_id
				booking.number_of_nights
			end
		end

		def update_total_price
			if every_day == 0
				self.total_price = unit_price * number_of_units
			elsif every_day == 1
				self.total_price = unit_price * number_of_units * number_of_days
			end
		end

		def set_account_id
			if trip_id
				self.account_id = trip.account_id
			elsif booking_id
				self.account_id = booking.account_id
			end
		end
end
