class Room < ActiveRecord::Base
	ROOM_OCCUPANCY_TYPES = [ "Double", "Single" ]

	belongs_to :booking
	belongs_to :room_type

	has_many :line_items, dependent: :destroy

	before_validation :set_defaults_if_nil, :update_check_in_date, :update_number_of_nights,
		:update_check_out_date, :update_account_id

	validates :occupancy, :number_of_rooms, presence: true
	validates :occupancy, :inclusion => { :in => ROOM_OCCUPANCY_TYPES,
		:message => ": \"%{value}\" is not a valid option" }
	validates :number_of_adults, allow_nil: true,
		:inclusion => { :in => [1, 2, 3, 4],
		:message => ": %{value} is not a valid option" }
	validates_numericality_of :number_of_rooms,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: ": %{value} should be a number greater than 0"
	validates :number_of_children_between_5_and_12_years, 
		:number_of_children_below_5_years, allow_nil: true,
		:inclusion => { :in => [0, 1, 2, 3],
		:message => ": %{value} is not a valid option" }

	validate :ensure_room_type_exists, :ensure_room_availability

	after_validation :update_line_items

	before_create :update_number_of_adults, :update_room_rate, 
							:update_food_rate, :update_lodging_rate, :update_transportation_and_guide_rate,
							:update_taxable_value, :update_cgst, :update_sgst, :update_total_price, :update_discount

	before_update :update_number_of_adults, :update_room_rate, 
							:update_food_rate, :update_lodging_rate, :update_transportation_and_guide_rate,
							:update_taxable_value, :update_cgst, :update_sgst, :update_total_price, :update_discount

	before_destroy :ensure_payments_are_not_made

	def meal_plan
		booking.meal_plan
	end

	def food_value
		food_rate * number_of_rooms * number_of_nights
	end

	def transportation_and_guide_value
		transportation_and_guide_rate * number_of_rooms * number_of_nights
	end

	def lodging_value
		lodging_rate * number_of_rooms * number_of_nights
	end

	def food_discount
		(food_value * discount_percentage / 100.0).round
	end

	def transportation_and_guide_discount
		(transportation_and_guide_value * discount_percentage / 100.0).round
	end

	def lodging_discount
		(lodging_value * discount_percentage / 100.0).round
	end

	def food_taxable_value
		(food_value * (100 - discount_percentage) / 100.0).round
	end

	def transportation_and_guide_taxable_value
		(transportation_and_guide_value * (100 - discount_percentage) / 100.0).round
	end

	def lodging_taxable_value
		if cancelled == 1
			cancellation_charge
		else
			(lodging_value * (100 - discount_percentage) / 100.0).round
		end
	end

	def cgst_rate_for_food
		room_type.property.cgst_rate_for_food
	end

	def sgst_rate_for_food
		room_type.property.sgst_rate_for_food
	end

	def cgst_rate_for_tour_operator_services
		room_type.property.cgst_rate_for_tour_operator_services
	end

	def sgst_rate_for_tour_operator_services
		room_type.property.sgst_rate_for_tour_operator_services
	end

	def cgst_rate
		room_type.cgst_rate
	end

	def sgst_rate
		room_type.sgst_rate
	end

	def food_cgst
		(food_taxable_value * cgst_rate_for_food / 100.0).round
	end

	def food_sgst
		(food_taxable_value * sgst_rate_for_food / 100.0).round
	end

	def transportation_and_guide_cgst
		(transportation_and_guide_taxable_value * cgst_rate_for_tour_operator_services / 100.0).round
	end

	def transportation_and_guide_sgst
		(transportation_and_guide_taxable_value * sgst_rate_for_tour_operator_services / 100.0).round
	end

	def lodging_cgst
		(lodging_taxable_value * cgst_rate / 100.0).round
	end

	def lodging_sgst
		(lodging_taxable_value * sgst_rate / 100.0).round
	end

	def food_total_price
		food_taxable_value + food_cgst + food_sgst
	end

	def transportation_and_guide_total_price
		transportation_and_guide_taxable_value + transportation_and_guide_cgst + transportation_and_guide_sgst
	end

	def lodging_total_price
		lodging_taxable_value + lodging_cgst + lodging_sgst
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

	def value
		food_value + transportation_and_guide_value + lodging_value
	end

	def total_price_excl_discount_and_tax
		if cancelled == 1
			cancellation_charge
		else
			room_rate * number_of_rooms * number_of_nights
		end
	end

	private
		def set_defaults_if_nil
			self.number_of_children_between_5_and_12_years ||= 0
			self.number_of_children_below_5_years ||= 0
			self.vat ||= 0
			self.service_tax ||= 0
			self.luxury_tax ||= 0
			self.discount ||= 0
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

		def update_account_id
			if booking_id
				self.account_id = booking.account_id
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
			if errors.blank? and room_type_id
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

		def update_line_items
      if errors.blank?
        if !new_record?
		      delete_line_items
        end
			  if room_type.ensure_availability_before_booking == 1 and cancelled == 0
		      create_line_items
        end
      end
		end
	
	  def delete_line_items
		  if line_items.any?
			  line_items.destroy_all
		  end
	  end

		def create_line_items
			date = check_in_date
			while date < check_out_date do
				line_item = line_items.build(room_type_id: room_type_id,
					date: date,
					booked_rooms: number_of_rooms,
           account_id: account_id)
				line_item.save!
				date += 1
			end
		end

		def update_number_of_adults
			if occupancy == "Double"
				self.number_of_adults = 2
			else
				self.number_of_adults = 1
			end
		end

		def update_room_rate
			if cancelled == 1
				self.room_rate = 0
			else
				if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
					self.room_rate = room_type.price(occupancy, number_of_adults, number_of_children_between_5_and_12_years,
						number_of_children_below_5_years, check_in_date, meal_plan, "TOTAL_PRICE")
				end
			end
		end

		def update_food_rate
			if cancelled == 1
				self.food_rate = 0
			else
				if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
					self.food_rate = room_type.price(occupancy, number_of_adults, number_of_children_between_5_and_12_years,
						number_of_children_below_5_years, check_in_date, meal_plan, "FOOD")
				end
			end
		end

		def update_transportation_and_guide_rate
			if cancelled == 1
				self.transportation_and_guide_rate = 0
			else
				if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
					self.transportation_and_guide_rate = room_type.price(occupancy, number_of_adults, 
						number_of_children_between_5_and_12_years, number_of_children_below_5_years, 
						check_in_date, meal_plan, "TRANSPORTATION_AND_GUIDE")
				end
			end
		end

		def update_lodging_rate
			if cancelled == 1
				self.lodging_rate = 0
			else
				if booking.trip.payment_status == Trip::NOT_PAID or room_rate == nil
					self.lodging_rate = room_type.price(occupancy, number_of_adults, number_of_children_between_5_and_12_years, 
						number_of_children_below_5_years, check_in_date, meal_plan, "LODGING")
				end
			end
		end

		def update_discount
			if cancelled == 1
				self.discount = 0
			else
				self.discount = food_discount + transportation_and_guide_discount + lodging_discount
			end
		end

		def update_taxable_value
			self.taxable_value = food_taxable_value + transportation_and_guide_taxable_value + lodging_taxable_value
		end

		def update_cgst
			self.cgst = food_cgst + transportation_and_guide_cgst + lodging_cgst
		end

		def update_sgst
			self.sgst = food_sgst + transportation_and_guide_sgst + lodging_sgst
		end

		def update_total_price
			self.total_price = taxable_value + cgst + sgst
		end

	def update_vat
		vat_rate = room_type.property.vat_rate.to_f / 100.0

		self.vat = ((food_value / (1 + vat_rate)) * vat_rate).ceil
	end

	def update_luxury_tax
		luxury_tax_rate = room_type.property.luxury_tax_rate.to_f / 100.0
		service_tax_rate = room_type.property.service_tax_rate.to_f / 100.0

		total_lodging_tax_rate = luxury_tax_rate + service_tax_rate

		self.luxury_tax = ((lodging_value / (1 + total_lodging_tax_rate)) * luxury_tax_rate).ceil
	end

	def update_service_tax
		luxury_tax_rate = room_type.property.luxury_tax_rate.to_f / 100.0
		service_tax_rate = room_type.property.service_tax_rate.to_f / 100.0
		tour_operator_service_tax_rate = AccountSetting.find_by_account_id(account_id).tour_operator_service_tax_rate.to_f / 100.0

		total_lodging_tax_rate = luxury_tax_rate + service_tax_rate

		self.service_tax = (((lodging_value / (1 + total_lodging_tax_rate)) * service_tax_rate) +
		((transportation_and_guide_value / (1 + tour_operator_service_tax_rate)) * tour_operator_service_tax_rate)).ceil
	end

	def ensure_payments_are_not_made
		if booking.trip.payment_status == Trip::NOT_PAID
			return true
		else
			errors.add(:base, "Could not delete room booking as payments have been made for the trip")
			return false
		end
	end
end
