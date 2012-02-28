class Trip < ActiveRecord::Base
	NOT_PAID = 'Not Paid'
	PARTIALLY_PAID = 'Partially Paid'
	FULLY_PAID = 'Fully Paid'

	belongs_to :guest

	belongs_to :agency

	belongs_to :advisor

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :bookings

	has_many :taxi_bookings

	has_many :trek_bookings

	has_many :payments, dependent: :destroy
	accepts_nested_attributes_for :payments, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :vas_bookings, dependent: :destroy
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true

	before_validation :update_end_date

	before_save :set_defaults_if_nil, :update_vas_unit_price,
							:update_payment_status, :update_pay_by_date

	after_save :update_line_item_status

	before_destroy :ensure_not_referenced_by_booking

	validates :guest_id, :name, :start_date, :end_date, :number_of_days, 
						presence: true

	validates_numericality_of :guest_id, :number_of_days,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_below_5_years, 
						:number_of_drivers,
						only_integer: true, greater_than_or_equal_to: 0, allow_nil: true,
						message: "should be a number greater than or equal to 0"

	validate :ensure_guest_exists, :ensure_end_date_is_greater_than_start_date

	attr_accessor :name_for_receipts

	after_find do |trip|
		if trip.payee_name != ""
			@name_for_receipts = trip.payee_name
		else
			@name_for_receipts = trip.guest.name
		end
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

	def number_of_rooms
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| room.number_of_rooms }
		end
	end

	def number_of_guests
		guests = number_of_adults + number_of_children_between_5_and_12_years +
							number_of_children_below_5_years

		return guests
	end

	def total_price
		if bookings.any?
			price_for_bookings = bookings.to_a.sum { |booking| booking.total_price }
		else
			price_for_bookings = 0
		end

		if vas_bookings.any?
			price_for_vas = vas_bookings.to_a.sum { |vas_booking|
				vas_booking.unit_price * vas_booking.number_of_people *
					vas_booking.number_of_days }
		else
			price_for_vas = 0
		end

		if taxi_bookings.any?
			price_for_transport = taxi_bookings.to_a.sum { |taxi_booking|
				taxi_booking.unit_price * taxi_booking.number_of_vehicles *
					number_of_days }
		else
			price_for_transport = 0
		end

		if trek_bookings.any?
			price_for_treks = trek_bookings.to_a.sum { |trek_booking|
				trek_booking.unit_price * number_of_guests * 
					trek_booking.number_of_days }
		else
			price_for_treks = 0
		end

		ttl_price = price_for_bookings + price_for_vas + price_for_transport +
									price_for_treks

		return ttl_price
	end

	def service_tax
		if bookings.any?
			service_tax = bookings.to_a.sum { |booking| booking.service_tax }
		else
			service_tax = 0
		end
		
		if service_tax != 0
			service_tax_rounded = ((service_tax / 100).to_i + 1) * 100
		else
			service_tax_rounded = 0
		end

		return service_tax_rounded
	end

	def paid
		if payments.empty?
			return 0
		else
			payments.to_a.sum { |payment| payment.amount }
		end
	end

	def balance_payment
		final_price - paid
	end

	def final_price
		if discount != nil
			final_price = total_price - discount
		else
			final_price = total_price
		end
		
		if service_tax != nil
			final_price += service_tax
		end

		return final_price
	end

	def long_name
		guest.name + ' - ' + name
	end

	private

		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

		def update_payment_status
			if total_price == 0
				pay_status = NOT_PAID
			elsif total_price > 0 and balance_payment <= 0
				pay_status = FULLY_PAID
			elsif total_price > 0 and balance_payment > 0 and paid > 0
				pay_status = PARTIALLY_PAID
			else
				pay_status = NOT_PAID
			end
	
			self.payment_status = pay_status
		end

		def update_pay_by_date
			if new_record?
				self.pay_by_date = Date.today.to_date + 2
			else	
				if payment_status == FULLY_PAID
					self.pay_by_date = nil
				elsif payment_status == PARTIALLY_PAID
					self.pay_by_date = start_date - 21
				else
					self.pay_by_date = created_at.to_date + 2
				end
			end
		end

		def ensure_guest_exists
			begin
				guest = Guest.find(guest_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Trip as Guest '#{guest_id}' does not exist")
				return false
			else
				return true
			end
		end	

		def set_defaults_if_nil
			self.number_of_children_below_5_years ||= 0
			self.number_of_drivers ||= 0
			self.discount ||= 0
		end

		def ensure_not_referenced_by_booking
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because the trip '#{name}' has bookings. Please destroy the bookings first.")
				return false
			end
		end

		def ensure_end_date_is_greater_than_start_date
			if end_date <= start_date
				errors.add(:base, "Could not create Trip as end date is earlier than start date")
				return false
			end
		end

		def update_line_item_status
			if payment_status == NOT_PAID
				blocked = 1
			else
				blocked = 0
			end

			if bookings.any?
				bookings.each do |booking|
					booking.line_items.each do |line_item|
						line_item.blocked = blocked
						line_item.save!
					end
				end
			end
		end

		def update_vas_unit_price
			if vas_bookings.any?
				vas_bookings.each do |vas_booking|
					vas_booking.unit_price = ValueAddedService.unit_price(
																		vas_booking.value_added_service_id,
																		vas_booking.number_of_people)
					if !vas_booking.unit_price or vas_booking.unit_price == 0
						errors.add(:base, "Could not create Trip as price for
							'#{vas_booking.value_added_service.name}' and 
							#{vas_booking.number_of_people} people was not found")
						return false
					end
				end
			end
		end

end
