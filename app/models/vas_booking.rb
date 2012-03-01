class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking
	belongs_to :value_added_service

	validate :has_min_people
	
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
end
