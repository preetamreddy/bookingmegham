class Booking < ActiveRecord::Base

	belongs_to :trip
	belongs_to :room_type

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :vas_bookings, dependent: :destroy
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :line_items, dependent: :destroy

	before_validation :update_number_of_rooms, :update_check_out_date

	before_create :update_guest_id, :update_property_id

	before_save :initialize_attributes_when_nil,
							:update_room_rate, :update_vas_unit_price,
							:update_total_price, :update_service_tax

	before_destroy :ensure_payments_are_not_made

	after_save :update_line_items

	validates :trip_id, :room_type_id, :check_in_date, :check_out_date,
											presence: true

	validates_numericality_of :trip_id, :room_type_id,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"

	validates_numericality_of :number_of_drivers,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a number greater than or equal to 0"

	validate 	:ensure_trip_exists, :ensure_room_type_exists,
						:ensure_check_out_date_is_greater_than_check_in_date,
						:ensure_booking_is_within_trip_dates,
						:ensure_room_availability

	def number_of_children_below_5_years
		return trip.number_of_children_below_5_years
	end

	def food_preferences
		return trip.food_preferences
	end

	def add_rooms_from_trip(trip)
		trip.rooms.each do |trip_room|
			rooms.build(occupancy: trip_room.occupancy,
									number_of_adults: trip_room.number_of_adults,
									number_of_children_between_5_and_12_years: 
										trip_room.number_of_children_between_5_and_12_years,
									number_of_rooms: trip_room.number_of_rooms)
		end
	end

	def initialize_attributes_when_nil
		rooms.each do |room|
			if !room.number_of_children_between_5_and_12_years
				room.number_of_children_between_5_and_12_years = 0 
			end
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

	def update_room_rate
		rooms.each do |room|
			room.room_rate = RoomType.price(room_type_id, room.occupancy,
													room.number_of_adults,
													room.number_of_children_between_5_and_12_years)
		end
	end

	def update_vas_unit_price
		if vas_bookings.any?
			vas_bookings.each do |vas_booking|
				vas_booking.unit_price = ValueAddedService.unit_price(
																		vas_booking.value_added_service_id,
																		vas_booking.number_of_people)
				if vas_booking.unit_price == 0
					errors.add(:base, "Could not create Trip as
						'#{vas_booking.value_added_service.name}' requires more people")
					return false
				end
			end
		end
	end

	def update_total_price
		if rooms.any?
			price_per_night = rooms.to_a.sum { |room|
				room.room_rate * room.number_of_rooms }
		else
			price_per_night = 0
		end

		number_of_days = (check_out_date - check_in_date).to_i
		price_for_rooms = price_per_night * number_of_days

		if vas_bookings.any?
			price_for_vas = vas_bookings.to_a.sum { |vas_booking|
				vas_booking.unit_price * vas_booking.number_of_people * 
					vas_booking.number_of_days }
		else
			price_for_vas = 0
		end

		if number_of_drivers
			price_for_drivers = number_of_drivers * number_of_days *
														room_type.property.price_for_driver
		else
			price_for_drivers = 0
		end

		self.total_price = price_for_rooms + price_for_vas + price_for_drivers
	end

	def update_service_tax
		self.service_tax = number_of_nights * number_of_rooms * 
			room_type.price_for_room * RoomType::SERVICE_TAX_PERCENT / 100
	end

	def number_of_adults
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| room.number_of_adults * room.number_of_rooms }
		end
	end

	def number_of_children_between_5_and_12_years
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_between_5_and_12_years * room.number_of_rooms }
		end 
	end

	private

		def ensure_payments_are_not_made
			if trip.payment_status == Trip::NOT_PAID
				return true
			else
				errors.add(:base, "Could not delete booking as payments have been made for the trip")
				return false
			end
		end

		def update_check_out_date
			self.check_out_date = check_in_date + number_of_nights
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
		
		def ensure_check_out_date_is_greater_than_check_in_date
			if check_out_date <= check_in_date
				errors.add(:base, "Could not create Booking as check-out date is earlier than or same as check-in date")
				return false
			end
		end

		def ensure_booking_is_within_trip_dates
			if (check_in_date < trip.start_date or check_in_date > trip.end_date) or
					(check_out_date < trip.start_date or check_out_date > trip.end_date)
				errors.add(:base, "Could not create booking as it is not within the trip dates")
				return false
			end
		end

		def update_line_items
			if line_items.any?
				delete_line_items
			end

			if rooms.any?
				add_line_items
			end	
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

		def delete_line_items
			line_items.destroy_all
		end

		def update_guest_id
			self.guest_id = trip.guest_id
		end

		def update_property_id
			self.property_id = room_type.property_id
		end
end
