class RoomType < ActiveRecord::Base
	belongs_to :property

	has_many :bookings
	has_many :rooms
	has_many :line_items

	before_save :capitalize, :set_defaults_if_nil,
							:strip_whitespaces

	before_destroy :ensure_does_not_have_bookings

	validates :property_id, :room_type, presence: true
	
	validates_numericality_of :number_of_rooms,
														:price_for_single_occupancy,
														:price_for_double_occupancy,
														:price_for_lodging,
														allow_nil: true, only_integer: true,
														greater_than_or_equal_to: 0,
														message: "should be a number greater than or equal to 0"
	
	def service_tax
		(price_for_lodging * property.service_tax_rate.to_f / 100.0).round
	end

	def RoomType.price(id, occupancy, number_of_adults, number_of_children_between_5_and_12_years,
											number_of_children_below_5_years)
		room_type = RoomType.find(id)

		room_rate = 0
		if occupancy == 'Single'
			room_rate = room_type.price_for_single_occupancy
			if number_of_adults > 1
				extra_adults = (number_of_adults - 1)
			end
		else
			room_rate = room_type.price_for_double_occupancy
			if number_of_adults > 2
				extra_adults = (number_of_adults - 2)
			end
		end

		if extra_adults
			room_rate += extra_adults * room_type.price_for_triple_occupancy
		end

		if number_of_children_between_5_and_12_years > 0
			room_rate += number_of_children_between_5_and_12_years *
				room_type.price_for_children_between_5_and_12_years
		end	

		if number_of_children_below_5_years > 0
			room_rate += number_of_children_below_5_years *
				room_type.price_for_children_below_5_years
		end	

		return room_rate
	end

	def long_name
		property.name + ' - ' + room_type
	end

	def available_rooms(date)
		booked_rooms = LineItem.booked_rooms(id, date)	
		if booked_rooms
			available_rooms = number_of_rooms - booked_rooms
		else
			available_rooms = number_of_rooms	
		end

		return available_rooms
	end

	def ensure_availability_before_booking
		return property.ensure_availability_before_booking
	end

	def availability(start_date, end_date, rooms_required)
		availability_status = true
		if ensure_availability_before_booking == 1
			(start_date...end_date).each do |date|
				if available_rooms(date) < rooms_required
					availability_status = false
				end
			end
		end
		
		return availability_status
	end

	private
	
		def set_defaults_if_nil
			self.price_for_single_occupancy ||= 0
			self.price_for_double_occupancy ||= 0
			self.price_for_lodging ||= 0
			self.number_of_rooms ||= 99
		end

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{room_type} has bookings")
				return false
			end
		end

		def capitalize
			self.room_type = room_type.capitalize
		end
		
		def strip_whitespaces
			self.description = description.to_s.strip
		end
end
