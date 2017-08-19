class VasBooking < ActiveRecord::Base
	VAT = 'VAT'
	ST = 'ST'

	TAX_TYPES = [VAT, ST]

	belongs_to :trip
	belongs_to :booking

	validates :value_added_service, :unit_price, :number_of_units, presence: true
	validates_numericality_of :unit_price,
		allow_nil: true, only_integer: true, greater_than_or_equal_to: 0,
		message: ": %{value} should be a number greater than or equal to 0"
	validates_numericality_of :number_of_units,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: ": %{value} should be a number greater than 0"

	before_save :update_taxable_value, :update_cgst, :update_sgst, :update_total_price

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
		if trip_id
			AccountSetting.find_by_account_id(trip.account_id).cgst_rate_for_hotel_services
		elsif booking_id
			booking.property.cgst_rate
		end
	end

	def sgst_rate
		if trip_id
			AccountSetting.find_by_account_id(trip.account_id).sgst_rate_for_hotel_services
		elsif booking_id
			booking.property.sgst_rate
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

	private
		def update_taxable_value
				self.taxable_value = value - discount
		end

		def update_cgst
			self.cgst = (taxable_value * cgst_rate.to_f / 100).round
		end

		def update_sgst
			self.sgst = (taxable_value * sgst_rate.to_f / 100).round
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
