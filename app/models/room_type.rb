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

  before_update :set_rooms_to_zero_for_soft_deleted_room_types

	before_destroy :ensure_does_not_have_booked_rooms

	def service_tax
		service_tax_rate = property.service_tax_rate.to_f / 100.0

		((price_for_lodging / (1 + service_tax_rate)) * service_tax_rate).ceil
	end

	def price(occupancy, number_of_adults, number_of_children_between_5_and_12_years,
		number_of_children_below_5_years, check_in_date, meal_plan, return_value)

    		rates = get_rates(meal_plan, check_in_date)

		rate = 0
		if occupancy == 'Single'
			if return_value == "TOTAL_PRICE"
				rate = rates[:price_for_single_occupancy]
			elsif return_value == "FOOD"
				rate = rates[:price_for_food_on_single]
			elsif return_value == "LODGING"
				rate = rates[:price_for_lodging]
			elsif return_value == "TRANSPORTATION_AND_GUIDE"
				rate = rates[:price_for_transportation_and_guide]
			end
			if number_of_adults > 1
				extra_adults = (number_of_adults - 1)
			end
		else
			if return_value == "TOTAL_PRICE"
				rate = rates[:price_for_double_occupancy]
			elsif return_value == "FOOD"
				rate = rates[:price_for_food_on_double]
			elsif return_value == "LODGING"
				rate = rates[:price_for_lodging]
			elsif return_value == "TRANSPORTATION_AND_GUIDE"
				rate = rates[:price_for_transportation_and_guide]
			end
			if number_of_adults > 2
				extra_adults = (number_of_adults - 2)
			end
		end

		if return_value == "TOTAL_PRICE" or return_value == "FOOD"
			if extra_adults
				rate += extra_adults * rates[:price_for_extra_adults]
			end

			if number_of_children_between_5_and_12_years > 0
				rate += number_of_children_between_5_and_12_years * rates[:price_for_children]
			end	

			if number_of_children_below_5_years > 0
				rate += number_of_children_below_5_years * rates[:price_for_infants]
			end	
		end

		return rate
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
          :price_for_infants          => price_list.first.price_for_infants, 
          :price_for_lodging          => price_list.first.price_for_lodging,
          :price_for_food_on_single   => price_list.first.price_for_food_on_single,
          :price_for_food_on_double   => price_list.first.price_for_food_on_double,
          :price_for_transportation_and_guide => price_list.first.price_for_transportation_and_guide
	}
      else
        { :price_for_single_occupancy => price_for_single_occupancy,
          :price_for_double_occupancy => price_for_double_occupancy,
          :price_for_extra_adults     => price_for_triple_occupancy, 
          :price_for_children         => price_for_children_between_5_and_12_years,
          :price_for_infants          => price_for_children_below_5_years,
          :price_for_lodging          => price_for_lodging,
          :price_for_food_on_single   => price_for_food_on_single,
          :price_for_food_on_double   => price_for_food_on_double,
          :price_for_transportation_and_guide => price_for_transportation_and_guide
	}
      end
    end

		def capitalize
			self.room_type = room_type.capitalize
		end
	
		def strip_whitespaces
			self.description = description.to_s.strip
		end

    def set_rooms_to_zero_for_soft_deleted_room_types
      if deleted == 1
        self.number_of_rooms = 0
      end
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
