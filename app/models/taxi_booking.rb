class TaxiBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :taxi

	has_many :taxi_details, dependent: :destroy
		accepts_nested_attributes_for :taxi_details, :reject_if => :all_blank,
		:allow_destroy => true

	validates :trip_id, :taxi_id, :number_of_vehicles, presence: true

	before_save :update_unit_price, :titleize

	before_destroy :ensure_payments_are_not_made

	private
	
		def update_unit_price
			self.unit_price = taxi.unit_price
		end

		def ensure_payments_are_not_made
			if trip.payment_status == Trip::NOT_PAID
				return true
			else
				errors.add(:base, "Could not delete taxi booking as payments have been made for the trip")
				return false
			end
		end

		def titleize
			self.drop_off_city = drop_off_city.titleize
		end
end