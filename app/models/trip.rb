class Trip < ActiveRecord::Base
	NOT_PAID = 'Not Paid'
	PARTIALLY_PAID = 'Partially Paid'
	FULLY_PAID = 'Fully Paid'
	PAYMENT_OVERDUE = 'Payment Overdue'
	GUEST = "Guest"
	CHECKED_OUT = 'Checked Out'

	belongs_to :customer, :polymorphic => true
	belongs_to :advisor

	has_many :trip_rooms, dependent: :destroy
	accepts_nested_attributes_for :trip_rooms, :reject_if => :all_blank,
		:allow_destroy => true
	has_many :vas_bookings, dependent: :destroy
	accepts_nested_attributes_for :vas_bookings, :reject_if => :all_blank,
		:allow_destroy => true
	has_many :bookings
	has_many :taxi_bookings
	has_many :payments

	after_initialize :init

	before_validation :set_defaults_if_nil

	validates :customer_type, :customer_id, :advisor_id, :name, :start_date, :number_of_days, 
						presence: true
	validates_numericality_of :number_of_days,
						only_integer: true, greater_than: 1, allow_nil: true,
						message: "should be a number greater than 1"
	validates :phone_number, allow_nil: true, :allow_blank => true, :phone_number_format => true

	before_save :strip_whitespaces, :titleize, :update_end_date, :ensure_booking_dates_are_within_trip_dates,
              :ensure_customer_exists, :update_total_price

	before_update :update_payment_status_and_pay_by_date, :update_tds, :update_counter_for_tax_invoice

	before_destroy 	:ensure_does_not_have_bookings,
									:ensure_does_not_have_taxi_bookings,
									:ensure_does_not_have_payments

	def discount_and_tac_percent
    		if AccountSetting.find_by_account_id(account_id).tax_setting == AccountSetting::FIXED
			0
		else
			if price_for_rooms > 0
				((tac + discount).to_f / price_for_rooms) * 100
			else
				0
			end
		end
	end

	def vat_vas
		if bookings.empty?
			vat_vas = 0
		else
			vat_vas = bookings.to_a.sum { |booking| booking.vat_vas }
		end

		if vas_bookings.empty?
			vat_vas += 0
		else
			vat_vas += vas_bookings.to_a.sum { |vas_booking| vas_booking.vat }
		end

		vat_vas
	end

	def total_vat
		(vat * (100 - discount_and_tac_percent) / 100.0).ceil + vat_vas
	end

	def total_luxury_tax
		(luxury_tax * (100 - discount_and_tac_percent) / 100.0).ceil
	end

	def service_tax_vas
		if bookings.empty?
			service_tax_vas = 0
		else
			service_tax_vas = bookings.to_a.sum { |booking| booking.service_tax_vas }
		end

		if vas_bookings.empty?
			service_tax_vas += 0
		else
			service_tax_vas += vas_bookings.to_a.sum { |vas_booking| vas_booking.service_tax }
		end

		service_tax_vas
	end

	def service_tax_taxi
		if taxi_bookings.empty?
			0
		else
			taxi_bookings.to_a.sum { |taxi_booking| taxi_booking.service_tax }
		end
	end

	def total_service_tax
		(service_tax * (100 - discount_and_tac_percent) / 100.0).ceil + service_tax_vas + service_tax_taxi
	end

	def number_of_rooms
		if trip_rooms.empty?
			return 0
		else
			trip_rooms.to_a.sum { |trip_room| trip_room.number_of_rooms }
		end
	end

	def number_of_adults
		if trip_rooms.empty?
			return 0
		else
			trip_rooms.to_a.sum { |trip_room| trip_room.number_of_adults * trip_room.number_of_rooms }
		end
	end

	def number_of_children_between_5_and_12_years
		if trip_rooms.empty?
			return 0
		else
			trip_rooms.to_a.sum { |trip_room| 
				trip_room.number_of_children_between_5_and_12_years * trip_room.number_of_rooms }
		end
	end

	def number_of_children_below_5_years
		if trip_rooms.empty?
			return 0
		else
			trip_rooms.to_a.sum { |trip_room| 
				trip_room.number_of_children_below_5_years * trip_room.number_of_rooms }
		end
	end

	def number_of_guests
		number_of_adults + number_of_children_between_5_and_12_years + number_of_children_below_5_years
	end

	def number_of_children
		number_of_children_between_5_and_12_years + number_of_children_below_5_years
	end

	def guests
		guests = number_of_adults.to_s
		if number_of_children != 0
			guests = guests + " + " + number_of_children.to_s
		end

		return guests
	end

  def is_direct_booking?
    customer_type == GUEST ? true : false
  end

  def guest_name
    is_direct_booking? ? customer.name_with_title : name
  end

  def guest_name_with_agency
    is_direct_booking? ? customer.name : customer.name + ' - ' + name
  end

  def guest_phone_number
    is_direct_booking? ? customer.phone_number : phone_number
  end

  def name_with_dates
    name + " (" + start_date.to_s(:ddmonyy) + " to " + end_date.to_s(:ddmonyy) + ")"
  end

  def guest_name_with_agency_and_dates
    guest_name_with_agency + " (" + start_date.to_s(:ddmonyy) + " to " + end_date.to_s(:ddmonyy) + ")"
  end

  def tds_percent
    AccountSetting.find_by_account_id(account_id).tds_percent
  end

	def total_payable
		total_price + tds + round_off
	end

	def balance_payment
		if total_payable > paid
			total_payable - paid
		else
			0
		end
	end

	def refund_amount
		if paid > total_payable
			paid - total_payable
		else
			0
		end
	end

	def net_after_taxes
		taxable_value
	end

  def itinerary_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{id}"
  end

	def trip_year
		if end_date.month <= 3
			end_date.year - 1 - 2000
		else
			end_date.year - 2000
		end
	end

  def proforma_invoice_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{trip_year}/#{id}"
  end

  def tax_invoice_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{trip_year}/#{counter_for_tax_invoice}"
  end

	def invoice_number
		if checked_out == 1
			tax_invoice_number
		else
			proforma_invoice_number
		end
	end

  def voucher_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{id}"
  end

	def gst
		(cgst + sgst + igst).to_i
	end

	def total_price_excl_discount_and_taxes
		(total_price + discount + tac - gst).to_i
	end

	private
		def init
			self.discount ||= 0
			self.tac ||= 0
			self.payment_status ||= NOT_PAID
			self.vat ||= 0
			self.luxury_tax ||= 0
			self.banjara_vat ||= 0
			self.banjara_service_tax ||= 0
			self.banjara_luxury_tax ||= 0
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

    def ensure_booking_dates_are_within_trip_dates
      bookings.each do |booking|
        if booking.check_in_date < start_date or booking.check_out_date > end_date
          errors.add(:base, "Could not save Trip as bookings exist outside the trip dates")
          return false
        end
      end
      taxi_bookings.each do |taxi_booking|
        if taxi_booking.start_date < start_date or taxi_booking.end_date > end_date
          errors.add(:base, "Could not save Trip as taxi bookings exist outside the trip dates")
          return false
        end
      end
    end

    def ensure_customer_exists
      begin
        customer = customer_type.classify.constantize.find(customer_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:base, "Could not create Trip as customer does not exist")
        return false
      rescue NameError
        errors.add(:base, "Could not create Trip as customer does not exist")
        return false
      else
        return true
      end
    end

		def update_payment_status_and_pay_by_date
			if paid == 0
				self.payment_status = NOT_PAID
				self.pay_by_date = created_at.to_date + 2
			else 
				if balance_payment > 0
					self.payment_status = PARTIALLY_PAID
					self.pay_by_date = start_date - 7
				else
					self.payment_status = FULLY_PAID
					self.pay_by_date = nil
				end
			end	
		end

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has bookings")
				return false
			end
		end

		def ensure_does_not_have_taxi_bookings
			if taxi_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has taxi bookings")
				return false
			end
		end

		def ensure_does_not_have_payments
			if payments.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has payments")
				return false
			end
		end

		def update_tds
			if tds != 0
				self.tds = tac * tds_percent / 100
			end
		end

		def update_counter_for_tax_invoice
			account_setting = AccountSetting.find_by_account_id(account_id)
			if checked_out_changed? and checked_out == 1
				if for_own_properties == 1
					self.counter_for_tax_invoice = account_setting.own_property_counter_for_tax_invoice
					AccountSetting.update_counters account_setting.id, :own_property_counter_for_tax_invoice => 1
				else
					self.counter_for_tax_invoice = account_setting.tour_operator_counter_for_tax_invoice
					AccountSetting.update_counters account_setting.id, :tour_operator_counter_for_tax_invoice => 1
				end
			end
		end

		def update_total_price
			self.total_price = price_for_vas + price_for_transport + price_for_rooms
		end
end
