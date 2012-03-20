class Payment < ActiveRecord::Base
	PAYMENT_MODE = [ "Axis", "S.C.B.", "SCB(NEW)", "Cash" ]

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
			@name_for_receipts = payment.trip.guest.name
		end
	end

	comma do
		trip_id
		trip.guest.name
		"BCRPL/#{trip_id}/#{id}"
		date_received
		amount
		details
	end

	private

		def titleize
			if payee_name != "" or payee_name != nil
				self.payee_name = payee_name.titleize
			end
		end
end
