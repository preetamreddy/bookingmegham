class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking
	belongs_to :value_added_service

	validate :has_min_people

	before_create :set_account_id
	
	def total_price
		total_price = unit_price * number_of_people

		return total_price
	end

	private

		def has_min_people
			if number_of_people >= value_added_service.min_people
				return true
			else
				errors.add(:base, "#{value_added_service.name} needs minimum 
					#{value_added_service.min_people} people")
				return false
			end
		end

		def set_account_id
			if trip != nil
				self.account_id = trip.account_id
			elsif booking != nil
				self.account_id = booking.account_id
			end
		end
end
