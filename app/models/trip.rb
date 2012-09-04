class Trip < ActiveRecord::Base
	NOT_PAID = 'Not Paid'
	PARTIALLY_PAID = 'Partially Paid'
	FULLY_PAID = 'Fully Paid'
  GUEST = "Guest"

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

	validates :customer_type, :customer_id, :name, :start_date, :number_of_days, 
						presence: true
	validates_numericality_of :customer_id, :number_of_days,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"
  validates :phone_number, allow_nil: true,
        :format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	before_save :strip_whitespaces, :titleize,
							:update_end_date, :ensure_end_date_is_greater_than_start_date,
              :ensure_customer_exists

	before_update :update_payment_status_and_pay_by_date

	before_destroy 	:ensure_does_not_have_bookings,
									:ensure_does_not_have_taxi_bookings,
									:ensure_does_not_have_payments

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
    name + " (" + start_date.to_s(:short) + " to " + end_date.to_s(:short) + ")"
  end

	def total_price
		price_for_vas + price_for_transport + price_for_rooms
	end

  def tds_percent
    AccountSetting.find_by_account_id(account_id).tds_percent
  end

	def tds
		(tac * tds_percent / 100.0).round
	end

	def final_price
		total_price - discount - tac + tds
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

	def net_after_taxes
		final_price - tds - service_tax
	end

  def itinerary_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{id}"
  end

  def invoice_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{start_date.to_s(:year)}/#{id}"
  end

  def voucher_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
    "#{account_name_abbreviation}/#{id}"
  end

	private
		def init
			self.discount ||= 0
			self.tac ||= 0
			self.payment_status ||= NOT_PAID
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
					self.pay_by_date = start_date - 21
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
end
