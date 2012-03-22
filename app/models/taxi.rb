class Taxi < ActiveRecord::Base
	belongs_to :agency
	has_many :taxi_bookings

	validates :agency_id, :model, :max_passengers, :unit_price, presence: true

	before_save :strip_whitespaces, :titleize

	before_destroy :ensure_not_referenced_by_taxi_booking

	def long_name
		return "#{agency.name} - #{model}"
	end

	private
	
		def ensure_not_referenced_by_taxi_booking
			if taxi_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{long_name} has bookings")
				return false
			end
		end

		def titleize
			self.model = model.titleize
		end
		
		def strip_whitespaces
			self.terrain_limitations = terrain_limitations.to_s.strip
		end
end
