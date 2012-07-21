class Booking < ActiveRecord::Base
	MEAL_PLANS = ["EPAI", "CPAI", "MAPAI", "APAI"]

	belongs_to :trip
	belongs_to :room_type

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :vas_bookings, dependent: :destroy
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :line_items, dependent: :destroy

	before_validation :set_defaults_if_nil,
										:update_check_out_date, :update_number_of_rooms

	validates :trip_id, :room_type_id, :check_in_date, :check_out_date, :meal_plan,
											presence: true

	validates_numericality_of :trip_id, :room_type_id,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"

	validate	:ensure_check_out_date_is_greater_than_check_in_date,
						:ensure_trip_exists, :ensure_booking_is_within_trip_dates,
						:ensure_room_type_exists, :ensure_room_availability

	before_save :strip_whitespaces, :titleize,
							:update_suggested_activities,
							:update_total_price

	before_create :update_guest_id, :update_property_id

	after_save :update_line_items

	before_destroy :ensure_payments_are_not_made

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

	def price_for_drivers
		if number_of_drivers > 0
			number_of_drivers * number_of_nights * room_type.property.price_for_driver
		else
			0
		end
	end

	def final_price
		cancelled == 0 ? total_price : cancellation_charge
	end

	def add_rooms_from_trip(trip)
		trip.rooms.each do |trip_room|
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
			self.number_of_drivers ||= 0
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

		def ensure_room_type_exists
			begin
				room_type = RoomType.find(room_type_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Booking as Room Type '#{room_type_id}' does not exist")
				return false
 			else
        return true
			end
		end
		
		def ensure_room_availability
			if new_record?
				rooms_required = number_of_rooms
			else	
				rooms_required = number_of_rooms - number_of_rooms_was 
			end

			if rooms_required > 0
				if room_type.availability(check_in_date, check_out_date, rooms_required)
					return true
				else
					errors.add(:base, "Could not create booking due to unavailability of rooms")
					return false
				end
			end
		end

		def strip_whitespaces
			self.remarks = remarks.to_s.strip
			self.getting_there = getting_there.to_s.strip
			self.getting_home = getting_home.to_s.strip
		end

		def titleize
			self.guests_arriving_from = guests_arriving_from.titleize if guests_arriving_from
			self.departure_destination = departure_destination.titleize if departure_destination
		end

		def update_suggested_activities
			if suggested_activities == ""
				self.suggested_activities = room_type.property.suggested_activities.to_s.strip
			end
		end

		def update_total_price
			self.total_price = price_for_rooms + price_for_vas + price_for_drivers
		end

		def update_guest_id
			self.guest_id = trip.guest_id
		end

		def update_property_id
			self.property_id = room_type.property_id
		end

		def update_line_items
			if line_items.any?
				delete_line_items
			end

			if cancelled == 0 and rooms.any?
				add_line_items
			end	
		end

		def delete_line_items
			line_items.destroy_all
		end

		def add_line_items
			if trip.payment_status == Trip::NOT_PAID
				blocked = 1
			else
				blocked = 0
			end

			date = check_in_date
			while date < check_out_date do
				rooms.each do |room|
					line_item = line_items.build(room_type_id: room_type_id,
												date: date,
												booked_rooms: room.number_of_rooms,
												blocked: blocked)
					line_item.save!
				end
				date += 1
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
end
