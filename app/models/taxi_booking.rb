class TaxiBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :taxi

	has_many :taxi_details, dependent: :destroy
		accepts_nested_attributes_for :taxi_details, :reject_if => :all_blank,
		:allow_destroy => true

	validates :trip_id, :taxi_id, :number_of_vehicles, 
						:start_date, :number_of_days, presence: true

	before_save :update_end_date, :update_unit_price, :strip_whitespaces,
							:titleize

#	before_destroy :ensure_payments_are_not_made

	def total_price
		unit_price * number_of_days * number_of_vehicles
	end

	private
	
		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

		def update_unit_price
			if trip.payment_status == Trip::NOT_PAID
				self.unit_price = taxi.unit_price
			end
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
		
		def strip_whitespaces
			self.pickup_address = pickup_address.to_s.strip
		end
end
