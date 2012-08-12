class Room < ActiveRecord::Base
	ROOM_OCCUPANCY_TYPES = [ "Single", "Double" ]

	belongs_to :trip
	belongs_to :booking
	belongs_to :room_type

	has_many :line_items

	before_validation :set_defaults_if_nil, :update_room_type_id,
										:update_check_in_date, :update_number_of_nights,
										:update_check_out_date

	validates :occupancy, :number_of_adults, :number_of_rooms, presence: true

	validates :occupancy, inclusion: ROOM_OCCUPANCY_TYPES

	validates :number_of_adults, allow_nil: true,
		:inclusion => { :in => [1, 2, 3, 4],
		:message => "%{value} is not a valid option for number of adults / room" }

	validates_numericality_of :number_of_rooms,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: "%{value} should be a number greater than 0"

	validates :number_of_children_between_5_and_12_years, 
		:number_of_children_below_5_years, allow_nil: true,
		:inclusion => { :in => [0, 1, 2, 3],
		:message => "%{value} is not a valid option for number of children / room" }

	validate :ensure_room_availability

	before_create :set_account_id,
								:update_service_tax_per_room_night,
								:update_room_rate,
								:update_total_price,
								:update_service_tax

	before_update :update_room_rate,
								:update_total_price,
								:update_service_tax

	def guests_per_room
		if number_of_children_between_5_and_12_years == 0
			" " + number_of_adults.to_s
		else
			" " + number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s
		end
	end

	def all_guests_per_room
		if number_of_children_between_5_and_12_years == 0 and number_of_children_below_5_years == 0
			number_of_adults.to_s
		elsif number_of_children_below_5_years == 0
			number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s
		else
			number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s + "+" + number_of_children_below_5_years.to_s
		end
	end

	private
		def set_defaults_if_nil
			self.number_of_children_between_5_and_12_years ||= 0
			self.number_of_children_below_5_years ||= 0
		end

		def update_room_type_id
			if booking_id
				self.room_type_id = booking.room_type_id
			end
		end

		def update_check_in_date
			if booking_id
				self.check_in_date = booking.check_in_date
			end
		end

		def update_number_of_nights
			if booking_id
				self.number_of_nights = booking.number_of_nights
			end
		end

		def update_check_out_date
			if check_in_date and number_of_nights
				self.check_out_date = check_in_date + number_of_nights
			end
		end

		def ensure_room_availability
			if room_type_id
				if new_record? or room_type_id_changed?
					rooms_required = number_of_rooms
				else
					rooms_required = number_of_rooms - number_of_rooms_was 
				end
	
				if rooms_required > 0
					room_type = RoomType.find(room_type_id)
	
					if room_type.availability(check_in_date, check_out_date, rooms_required)
						return true
					else
						errors.add(:base,
							"Could not create booking due to unavailability of rooms for room type #{room_type.room_type}")
						return false
					end
				end
			end
		end

		def set_account_id
			if trip_id
				self.account_id = trip.account_id
			elsif booking_id
				self.account_id = booking.account_id
			end
		end

		def update_service_tax_per_room_night
			if booking_id
				self.service_tax_per_room_night = RoomType.find(room_type_id).service_tax
			end
		end

		def update_room_rate
			if booking_id
				if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
					self.room_rate = RoomType.price(room_type_id,
														occupancy,
														number_of_adults,
														number_of_children_between_5_and_12_years,
														number_of_children_below_5_years)
				end
			end
		end

		def update_total_price
			if booking_id
				self.total_price = booking_id ? room_rate * number_of_rooms * number_of_nights : nil
			end
		end

		def update_service_tax
			if booking_id
				self.service_tax = booking_id ? service_tax_per_room_night * number_of_rooms * number_of_nights : nil
			end
		end
end
