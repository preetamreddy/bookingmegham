class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking
	belongs_to :value_added_service

	before_create :update_unit_price

	validate :has_min_people
	
	def total_price
		total_price = unit_price * number_of_people

		return total_price
	end

	private

		def update_unit_price
			self.unit_price = value_added_service.unit_price
		end

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
