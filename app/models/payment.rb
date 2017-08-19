class Payment < ActiveRecord::Base
	belongs_to :trip

	validates :trip_id, :date_received, :amount, :payment_mode, presence: true
	validates_numericality_of :amount,
		only_integer: true, greater_than: 0, allow_nil: true,
		message: "should be a number greater than 0"

	before_save :set_payee_name, :titleize

  before_create :set_counter

	def receipt_number
    account_name_abbreviation = AccountSetting.find_by_account_id(account_id).name_abbreviation
		"#{account_name_abbreviation}/#{trip_id}/#{counter}"
	end

	def customer_name
		trip.customer.name
	end

	def date_final_payment
		if trip.payment_status == Trip::FULLY_PAID
			return trip.payments.order(:date_received).last.date_received
		else
			return ""
		end
	end

	comma do
		trip_id 'Trip ID'
		customer_name 'Customer'
		trip :customer_type => 'Customer Type'
		trip :start_date => 'Trip Start Dt'
		date_final_payment 'Date of Full Payment'
		receipt_number 'Rcpt No.'
		date_received 'Date of Payment'
		amount 'Amount Recd.'
		payment_mode 'Payment Mode'
		details 'Payment Details'
		trip :total_payable => 'Booking Cost Total'
		trip :paid => 'Total Recd.'
		trip :balance_payment => 'Balance'
		trip :discount => 'Discount'
		trip :tac => 'TAC'
		trip :tds => 'TDS'
		trip :service_tax => 'Service Tax'
		trip :net_after_taxes => 'Net After Taxes'
		trip :total_payable => 'Final Price'
	end

	private
    def set_payee_name
      self.payee_name = trip.customer.name_with_title if payee_name == '' or payee_name == nil
    end

		def titleize
			if payee_name != "" or payee_name != nil
				self.payee_name = payee_name.titleize
			end
		end

    def set_counter
      self.counter = trip.payments_counter + 1
    end
end
