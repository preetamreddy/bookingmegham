class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking

	validates :unit_price, :number_of_units, presence: true

	before_save :update_total_price

	before_create :set_account_id

	private

		def update_total_price
			self.total_price = unit_price * number_of_units
		end

		def set_account_id
			if trip != nil
				self.account_id = trip.account_id
			elsif booking != nil
				self.account_id = booking.account_id
			end
		end
end
