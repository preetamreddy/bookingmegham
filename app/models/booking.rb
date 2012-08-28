class Booking < ActiveRecord::Base
	MEAL_PLANS = ["EPAI", "CPAI", "MAPAI", "APAI"]

	belongs_to :trip
	belongs_to :property

	has_many :rooms
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true
	has_many :vas_bookings
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true

	before_validation :set_defaults_if_nil, :update_check_out_date, :update_number_of_rooms

	validates :trip_id, :check_in_date, :check_out_date, :meal_plan,
											presence: true
	validates_numericality_of :trip_id,
		only_integer: true, greater_than: 0, allow_nil: true, 
		message: "should be a number greater than 0"

	validate	:ensure_check_out_date_is_greater_than_check_in_date,
						:ensure_property_exists,
						:ensure_trip_exists, :ensure_booking_is_within_trip_dates

	before_save :strip_whitespaces, :titleize,
							:update_total_price

	before_destroy :ensure_payments_are_not_made,
		:ensure_does_not_have_rooms,
    :ensure_does_not_have_vas_bookings

  after_update :delete_line_items_for_cancelled_bookings

	def ensure_availability_before_booking
		property.ensure_availability_before_booking
	end

	def food_preferences
		trip.food_preferences
	end

	def medical_constraints
		trip.medical_constraints
	end

	def number_of_adults
		if rooms.empty?
			0
		else
			rooms.to_a.sum { |room| room.number_of_adults * room.number_of_rooms }
		end
	end

	def number_of_children_between_5_and_12_years
		if rooms.empty?
			0
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_between_5_and_12_years * room.number_of_rooms }
		end 
	end

	def number_of_children_below_5_years
		if rooms.empty?
			0
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_below_5_years * room.number_of_rooms }
		end 
	end

	def add_rooms_from_trip(trip)
		trip.trip_rooms.each do |trip_room|
			rooms.build(occupancy: trip_room.occupancy,
									number_of_adults: trip_room.number_of_adults,
									number_of_children_between_5_and_12_years: 
										trip_room.number_of_children_between_5_and_12_years,
									number_of_children_below_5_years: 
										trip_room.number_of_children_below_5_years,
									number_of_rooms: trip_room.number_of_rooms)
		end
	end

	private
    def set_defaults_if_nil
      self.remarks ||= trip.remarks
    end

		def update_check_out_date
			if check_in_date and number_of_nights != nil
				self.check_out_date = check_in_date + number_of_nights
			else
				errors.add(:base, "Please input check in date and number of nights")
				return false
			end
		end

		def update_number_of_rooms
			if rooms.any?
				num_rooms = rooms.to_a.sum { |room| room.number_of_rooms }
			else
				num_rooms = 0
			end
	
			self.number_of_rooms = num_rooms
		end

		def ensure_check_out_date_is_greater_than_check_in_date
			if check_out_date <= check_in_date
				errors.add(:base, "Could not create Booking as check-out date is earlier than or same as check-in date")
				return false
			end
		end

		def ensure_property_exists
			begin
				property = Property.find(property_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Booking as Property '#{property_id}' does not exist")
				return false
 			else
        return true
			end
		end

		def ensure_trip_exists
			begin
				trip = Trip.find(trip_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Booking as Trip '#{trip_id}' does not exist")
				return false
 			else
        return true
			end
		end

		def ensure_booking_is_within_trip_dates
			if (check_in_date < trip.start_date or check_in_date > trip.end_date) or
					(check_out_date < trip.start_date or check_out_date > trip.end_date)
				errors.add(:base, "Could not create booking as it is not within the trip dates")
				return false
			end
		end

		def strip_whitespaces
			self.remarks = remarks.to_s.strip
		end

		def titleize
			self.guests_arriving_from = guests_arriving_from.titleize if guests_arriving_from
			self.departure_destination = departure_destination.titleize if departure_destination
		end

		def update_total_price
			if cancelled == 0
				self.total_price = price_for_rooms + price_for_vas
			else
				self.total_price = cancellation_charge
			end
		end

		def ensure_payments_are_not_made
			if trip.payment_status == Trip::NOT_PAID
				return true
			else
				errors.add(:base, "Could not delete booking as payments have been made for the trip")
				return false
			end
		end

		def ensure_does_not_have_rooms
			if rooms.empty?
				return true
			else
				errors.add(:base, "Destroy failed because booking has rooms")
				return false
			end
		end

		def ensure_does_not_have_vas_bookings
			if vas_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because booking has value added services")
				return false
			end
		end

    def delete_line_items_for_cancelled_bookings
		  if cancelled_changed? and cancelled == 1
        rooms.all.each do |room|
			    room.delete_line_items
        end
		  end
    end
end
