class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking

	before_create :set_account_id
	
	def total_price
		total_price = unit_price * number_of_units

		return total_price
	end

	private

		def set_account_id
			if trip != nil
				self.account_id = trip.account_id
			elsif booking != nil
				self.account_id = booking.account_id
			end
		end
end
