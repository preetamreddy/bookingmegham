class VasBooking < ActiveRecord::Base
	VAT = 'VAT'
	ST = 'ST'

	TAX_TYPES = ["0-PERCENT", "5-PERCENT", "12-PERCENT", "18-PERCENT", "28-PERCENT", "VAT", "ST"]

	belongs_to :trip
	belongs_to :booking

	validates :value_added_service, :unit_price, :number_of_units, presence: true
	validates_numericality_of :unit_price,
		allow_nil: true, only_integer: true, greater_than_or_equal_to: 0,
		message: ": %{value} should be a number greater than or equal to 0"
	validates_numericality_of :number_of_units,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: ": %{value} should be a number greater than 0"

	before_save :update_discount, :update_taxable_value, :update_cgst, :update_sgst, :update_total_price

	before_create :set_account_id

	def vat
		if tax_type == VAT
			vat_rate = AccountSetting.find_by_account_id(account_id).vat_rate.to_f / 100.0

			((total_price / (1 + vat_rate)) * vat_rate).ceil
		else
			0
		end
	end

	def service_tax
		if tax_type == ST
			service_tax_rate = AccountSetting.find_by_account_id(account_id).service_tax_rate.to_f / 100.0

			((total_price / (1 + service_tax_rate)) * service_tax_rate).ceil
		else
			0
		end
	end

	def cgst_rate
		if tax_type == "0-PERCENT"
			0
		elsif tax_type == "5-PERCENT"
			2.5	
		elsif tax_type == "12-PERCENT"
			6	
		elsif tax_type == "18-PERCENT"
			9	
		elsif tax_type == "28-PERCENT"
			14	
		end
	end

	def sgst_rate
		if tax_type == "0-PERCENT"
			0
		elsif tax_type == "5-PERCENT"
			2.5	
		elsif tax_type == "12-PERCENT"
			6	
		elsif tax_type == "18-PERCENT"
			9	
		elsif tax_type == "28-PERCENT"
			14	
		end
	end

	def number_of_days
		if trip_id
			trip.number_of_days
		elsif booking_id
			booking.number_of_nights
		end
	end

	def value
		if every_day == 0
			unit_price * number_of_units
		elsif every_day == 1
			unit_price * number_of_units * number_of_days
		end
	end

	def gst
		(cgst + sgst).to_i
	end

	def total_price_excl_discount_and_taxes
		(total_price - gst + discount).to_i
	end

	private
		def update_discount
			self.discount = (value * discount_percentage / 100.0).round
		end

		def update_taxable_value
			self.taxable_value = (value * (100 - discount_percentage) / 100.0).round
		end

		def update_cgst
			self.cgst = (taxable_value * cgst_rate.to_f / 100.0).round
		end

		def update_sgst
			self.sgst = (taxable_value * sgst_rate.to_f / 100.0).round
		end

		def update_total_price
			self.total_price = taxable_value + cgst + sgst
		end

		def set_account_id
			if trip_id
				self.account_id = trip.account_id
			elsif booking_id
				self.account_id = booking.account_id
			end
		end
end
