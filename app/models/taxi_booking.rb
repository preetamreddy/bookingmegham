class TaxiBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :taxi

	has_many :taxi_details, dependent: :destroy
		accepts_nested_attributes_for :taxi_details, :reject_if => :all_blank,
		:allow_destroy => true

  before_validation :update_end_date

	validates :trip_id, :taxi_id, :start_date,
						:number_of_vehicles, :number_of_days,
						presence: true

  validate :ensure_taxi_booking_is_within_trip_dates

	before_save :strip_whitespaces, :titleize,
							:update_unit_price, :update_total_price

	private
		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

		def ensure_taxi_booking_is_within_trip_dates
			if (start_date < trip.start_date or start_date > trip.end_date) or
        (end_date < trip.start_date or end_date > trip.end_date)
				errors.add(:base, "Could not create taxi booking as it is not within the trip dates")
				return false
			end
		end

		def strip_whitespaces
			self.pickup_address = pickup_address.to_s.strip
		end

		def titleize
			self.drop_off_city = drop_off_city.titleize if drop_off_city
		end

		def update_unit_price
			if trip.payment_status == Trip::NOT_PAID or unit_price == nil
				self.unit_price = taxi.unit_price
			end
		end

		def update_total_price
			self.total_price = unit_price * number_of_vehicles * number_of_days
		end
end
