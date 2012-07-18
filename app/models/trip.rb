class Trip < ActiveRecord::Base
	NOT_PAID = 'Not Paid'
	PARTIALLY_PAID = 'Partially Paid'
	FULLY_PAID = 'Fully Paid'
	CONFIRMED_NOT_PAID = "Confirmed Not Paid"
	TDS_PERCENT = 10

	belongs_to :guest
	belongs_to :agency
	belongs_to :advisor

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :vas_bookings, dependent: :destroy
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :bookings
	has_many :taxi_bookings
	has_many :payments

	after_initialize :init

	before_validation :set_defaults_if_nil

	validates :guest_id, :name, :start_date, :number_of_days, 
						presence: true

	validates_numericality_of :guest_id, :number_of_days,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	before_save :strip_whitespaces, :titleize,
							:update_end_date, :ensure_end_date_is_greater_than_start_date,
							:ensure_guest_exists,
							:update_payment_status, :update_pay_by_date

	after_save :update_line_item_status

	before_destroy 	:ensure_not_referenced_by_booking,
									:ensure_not_referenced_by_taxi_booking

	def number_of_rooms
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| room.number_of_rooms }
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

	def number_of_children_below_5_years
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_below_5_years * room.number_of_rooms }
		end
	end

	def number_of_guests
		number_of_adults + number_of_children_between_5_and_12_years + number_of_children_below_5_years
	end

	def number_of_children
		number_of_children_between_5_and_12_years + number_of_children_below_5_years
	end

	def guests
		guests = "(" + number_of_adults.to_s
		if number_of_children_between_5_and_12_years != 0
			guests = guests + " + " + number_of_children_between_5_and_12_years.to_s
		end
		if number_of_children_below_5_years != 0
			guests = guests + " + " + number_of_children_below_5_years.to_s
		end
		guests = guests + ")"

		return guests
	end

	def long_name
		guest.name + ' - ' + name
	end

	def price_for_vas
		if vas_bookings.any? 
			price_for_vas = vas_bookings.to_a.sum { |vas_booking| vas_booking.total_price }
		else
			price_for_vas = 0
		end
	end

	def price_for_transport
		if taxi_bookings.any?
			price_for_transport = taxi_bookings.to_a.sum { |taxi_booking| taxi_booking.total_price }
		else
			price_for_transport = 0
		end
	end

	def price_for_room_bookings
		if bookings.any?
			bookings.to_a.sum { |booking| booking.final_price }
		else
			0
		end
	end

	def total_price
		price_for_vas + price_for_transport + price_for_room_bookings
	end

	def tds
		if direct_booking == 0
			(tac * TDS_PERCENT / 100.0).round
		else
			0
		end
	end

	def final_price
		total_price - discount - tac + tds
	end

	def paid
		if payments.empty?
			return 0
		else
			payments.to_a.sum { |payment| payment.amount }
		end
	end

	def balance_payment
		if final_price > paid
			final_price - paid
		else
			0
		end
	end

	def refund_amount
		if paid > final_price
			paid - final_price
		else
			0
		end
	end

	def service_tax
		if bookings.any?
			bookings.to_a.sum { |booking| booking.service_tax }
		else
			0
		end
	end

	def net_after_taxes
		final_price - tds - service_tax
	end

	private
		def init
			self.discount ||= 0
			self.tac ||= 0
			self.food_preferences ||= NOT_PAID
		end

		def set_defaults_if_nil
			self.invoice_date ||= Date.today
		end

		def titleize
			self.name = name.titleize
		end

		def strip_whitespaces
			self.remarks = remarks.to_s.strip
		end

		def update_end_date
			self.end_date = start_date + number_of_days - 1
		end

		def ensure_end_date_is_greater_than_start_date
			if end_date <= start_date
				errors.add(:base, "Could not create Trip as end date is earlier than start date")
				return false
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

		def ensure_not_referenced_by_booking
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has bookings")
				return false
			end
		end

		def ensure_not_referenced_by_taxi_booking
			if taxi_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has taxi bookings")
				return false
			end
		end
end
