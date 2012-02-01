class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking
	belongs_to :value_added_service

	def total_price
		total_price = unit_price * number_of_people * number_of_days

		return total_price
	end

end
