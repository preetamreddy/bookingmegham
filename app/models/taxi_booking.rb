class TaxiBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :taxi

	has_many :taxi_details, dependent: :destroy
		accepts_nested_attributes_for :taxi_details, :reject_if => :all_blank,
		:allow_destroy => true

	validates :trip_id, :taxi_id, :start_date,
						:number_of_vehicles, :number_of_days,
						presence: true

	before_save :strip_whitespaces, :titleize,
							:update_end_date,
							:update_unit_price, :update_total_price

	before_destroy :ensure_payments_are_not_made

	private
		def strip_whitespaces
			self.pickup_address = pickup_address.to_s.strip
		end

		def titleize
			self.drop_off_city = drop_off_city.titleize if drop_off_city
		end

		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

		def update_unit_price
			if trip.payment_status == Trip::NOT_PAID or unit_price == nil
				self.unit_price = taxi.unit_price
			end
		end

		def update_total_price
			self.total_price = unit_price * number_of_vehicles * number_of_days
		end

		def ensure_payments_are_not_made
			if trip.payment_status == Trip::NOT_PAID
				return true
			else
				errors.add(:base, "Could not delete taxi booking as payments have been made for the trip")
				return false
			end
		end
end
