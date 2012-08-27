class Room < ActiveRecord::Base
	ROOM_OCCUPANCY_TYPES = [ "Single", "Double" ]

	belongs_to :booking
	belongs_to :room_type

	has_many :line_items, dependent: :destroy

	before_validation :set_defaults_if_nil,
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

	validate :ensure_room_type_exists, :ensure_room_availability

	before_create :set_account_id,
								:update_service_tax_per_room_night,
								:update_room_rate,
								:update_total_price,
								:update_service_tax

	before_update :update_room_rate,
								:update_total_price,
								:update_service_tax

  after_create :create_line_items

  after_update :update_line_items

	def cancelled
		booking.cancelled
	end

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

		def ensure_room_type_exists
			if room_type_id
				begin
					room_type = RoomType.find(room_type_id)
				rescue ActiveRecord::RecordNotFound
					errors.add(:base, "Could not create Booking as Room Type '#{room_type_id}' does not exist")
					return false
 				else
        	return true
				end
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
			self.account_id = booking.account_id
		end

		def update_service_tax_per_room_night
			self.service_tax_per_room_night = room_type.service_tax
		end

		def update_room_rate
			if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
				self.room_rate = RoomType.price(room_type_id,
													occupancy,
													number_of_adults,
													number_of_children_between_5_and_12_years,
													number_of_children_below_5_years)
			end
		end

		def update_total_price
			self.total_price = room_rate * number_of_rooms * number_of_nights
		end

		def update_service_tax
			self.service_tax = service_tax_per_room_night * number_of_rooms * number_of_nights
		end

		def create_line_items
			if room_type.ensure_availability_before_booking == 1
				date = check_in_date
				while date < check_out_date do
					line_item = line_items.build(room_type_id: room_type_id,
						date: date,
						booked_rooms: number_of_rooms,
						booking_id: booking_id)
					line_item.save!
					date += 1
				end
			end
		end

		def update_line_items
			delete_line_items
			create_line_items
		end
	
		def delete_line_items
			if line_items.any?
				line_items.destroy_all
			end
		end
end
