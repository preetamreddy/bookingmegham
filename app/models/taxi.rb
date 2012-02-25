class Taxi < ActiveRecord::Base
	belongs_to :agency
	has_many :taxi_bookings

	validates :agency_id, :model, :max_passengers, :unit_price, presence: true

	before_destroy :ensure_not_referenced_by_taxi_booking

	def long_name
		return "#{agency.name} - #{model}"
	end

	private
	
		def ensure_not_referenced_by_taxi_booking
			if taxi_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because taxi '#{long_name}' has bookings.")
				return false
			end
		end
end
