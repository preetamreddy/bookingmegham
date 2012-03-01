class TrekBooking < ActiveRecord::Base
	belongs_to :trek
	belongs_to :trip

	before_validation :update_end_date

	before_save :titleize

	before_create :update_unit_price

	before_destroy :ensure_payments_are_not_made

	validate :ensure_booking_is_within_trip_dates

	def number_of_people
		number_of_people = trip.number_of_adults + 
			trip.number_of_children_between_5_and_12_years +
			trip.number_of_children_below_5_years

		return number_of_people
	end

	def total_price
		total_price = unit_price * number_of_people * number_of_days

		return total_price
	end

	private

		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

	  def update_unit_price
			unit_price = Trek.unit_price(trek_id, number_of_people)
			if unit_price == 0
				errors.add(:base, "Could not create Trek booking unit price for '#{trek.name}' trek could not be determined")
				return false
			else
				self.unit_price = unit_price
				return true
			end
		end

		def ensure_payments_are_not_made
			if trip.payment_status == Trip::NOT_PAID
				return true
			else
				errors.add(:base, "Could not delete trek booking as payments have been made for this trip")
				return false
			end
		end

		def ensure_booking_is_within_trip_dates
			if (start_date < trip.start_date or start_date > trip.end_date) or
					(end_date < trip.start_date or end_date > trip.end_date)
				errors.add(:base, "Could not create booking as it is not within the trip dates")
				return false
			end
		end

		def titleize
			self.origin = origin.titleize
			self.final_destination = final_destination.titleize
		end
end
