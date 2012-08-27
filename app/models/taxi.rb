class Taxi < ActiveRecord::Base
	belongs_to :agency

	has_many :taxi_bookings

	validates :agency_id, :model, :max_passengers, :unit_price, presence: true

	before_save :strip_whitespaces, :titleize

	before_destroy :ensure_does_not_have_taxi_bookings

	def long_name
		return "#{agency.name} - #{model}"
	end

	private
		def titleize
			self.model = model.titleize
		end
		
		def strip_whitespaces
			self.terrain_limitations = terrain_limitations.to_s.strip
		end

		def ensure_does_not_have_taxi_bookings
			if taxi_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{long_name} has bookings")
				return false
			end
		end
end
