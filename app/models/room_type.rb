class RoomType < ActiveRecord::Base
	belongs_to :property

	has_many :rooms
  has_many :price_lists, :dependent => :destroy

	validates :property_id, :room_type, :number_of_rooms,
		:price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_triple_occupancy, :price_for_children_between_5_and_12_years,
    :price_for_children_below_5_years, :price_for_lodging,
    presence: true
	validates_numericality_of :number_of_rooms,
		:price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_triple_occupancy, :price_for_children_between_5_and_12_years,
    :price_for_children_below_5_years, :price_for_lodging,
		allow_nil: true, only_integer: true, greater_than_or_equal_to: 0,
		message: "should be a number greater than or equal to 0"
	
	before_save :capitalize, :strip_whitespaces

	before_destroy :ensure_does_not_have_booked_rooms

	def service_tax
		(price_for_lodging * property.service_tax_rate / 100.0).round
	end

	def price(occupancy, number_of_adults, number_of_children_between_5_and_12_years,
											number_of_children_below_5_years, check_in_date, meal_plan)
    rates = get_rates(meal_plan, check_in_date)

		room_rate = 0
		if occupancy == 'Single'
			room_rate = rates[:price_for_single_occupancy]
			if number_of_adults > 1
				extra_adults = (number_of_adults - 1)
			end
		else
			room_rate = rates[:price_for_double_occupancy]
			if number_of_adults > 2
				extra_adults = (number_of_adults - 2)
			end
		end

		if extra_adults
			room_rate += extra_adults * rates[:price_for_extra_adults]
		end

		if number_of_children_between_5_and_12_years > 0
			room_rate += number_of_children_between_5_and_12_years * rates[:price_for_children]
		end	

		if number_of_children_below_5_years > 0
			room_rate += number_of_children_below_5_years * rates[:price_for_infants]
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
    def get_rates(meal_plan, check_in_date)
      price_list = PriceList.where('room_type_id = :room_type_id and meal_plan = :meal_plan and
                                    start_date <= :check_in_date and end_date >= :check_in_date',
                                  { :room_type_id => id, :meal_plan => meal_plan,
                                    :check_in_date => check_in_date })

      if price_list.count == 1
        { :price_for_single_occupancy => price_list.first.price_for_single_occupancy,
          :price_for_double_occupancy => price_list.first.price_for_double_occupancy,
          :price_for_extra_adults     => price_list.first.price_for_extra_adults, 
          :price_for_children         => price_list.first.price_for_children,
          :price_for_infants          => price_list.first.price_for_infants }
      else
        { :price_for_single_occupancy => price_for_single_occupancy,
          :price_for_double_occupancy => price_for_double_occupancy,
          :price_for_extra_adults     => price_for_triple_occupancy, 
          :price_for_children         => price_for_children_between_5_and_12_years,
          :price_for_infants          => price_for_children_below_5_years }
      end
    end

		def capitalize
			self.room_type = room_type.capitalize
		end
	
		def strip_whitespaces
			self.description = description.to_s.strip
		end

		def ensure_does_not_have_booked_rooms
			if rooms.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{long_name} has booked rooms")
				return false
			end
		end
end
