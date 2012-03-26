class Payment < ActiveRecord::Base
	PAYMENT_MODE = [ "Axis", "S.C.B.", "Cheque / DD", "Cash" ]

	belongs_to :trip

	validate :date_received, :amount, presence: true

	before_save :titleize

	validates_numericality_of :amount,
		only_integer: true, greater_than: 0, allow_nil: true,
		message: "should be a number greater than 0"

	attr_accessor :name_for_receipts

	after_find do |payment|
		if payment.payee_name != ""
			@name_for_receipts = payment.payee_name
		else
			@name_for_receipts = payment.trip.guest.name_with_title
		end
	end

	def receipt_number
		"BCRPL/#{trip_id}/#{id}"
	end

	def guest_name
		return trip.guest.name
	end

	def agency
		if trip.direct_booking == 0
			return trip.agency.short_name
		elsif trip.direct_booking == 1
			return ""
		end
	end

	def date_final_payment
		if trip.payment_status == Trip::FULLY_PAID
			return trip.payments.order(:date_received).last.date_received
		else
			return ""
		end
	end

	def agent_final_price
		if trip.direct_booking == 0
			return trip.final_price
		elsif trip.direct_booking == 1
			return 0
		end
	end

	def direct_final_price
		if trip.direct_booking == 1
			return trip.final_price
		elsif trip.direct_booking == 0
			return 0
		end
	end

	comma do
		trip_id 'Trip ID'
		guest_name
		agency
		trip :start_date => 'Trip Start Dt'
		date_final_payment 'Date of Full Payment'
		receipt_number 'Rcpt No.'
		date_received 'Date of Payment'
		amount 'Amount Recd.'
		payment_mode
		details 'Payment Details'
		trip :final_price => 'Booking Cost Total'
		trip :paid => 'Total Recd.'
		trip :balance_payment => 'Balance'
		trip :discount => 'Discount'
		trip :tac => 'TAC'
		trip :tds => 'TDS'
		trip :service_tax
		trip :net_after_taxes => 'Net After Taxes'
		agent_final_price 'Agent Booking'
		direct_final_price 'Direct Booking'
	end

	private

		def titleize
			if payee_name != "" or payee_name != nil
				self.payee_name = payee_name.titleize
			end
		end
end
