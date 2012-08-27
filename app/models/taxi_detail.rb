class TaxiDetail < ActiveRecord::Base
	belongs_to :taxi_booking

	before_save :upcase, :titleize

	before_create :set_account_id

	validates :registration_number, :driver_name, :driver_phone_number,
		presence: true

	validates :driver_phone_number, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	private
		def upcase
			self.registration_number = registration_number.upcase
		end

		def titleize
			self.driver_name = driver_name.titleize
		end

		def set_account_id
			self.account_id = taxi_booking.account_id
		end
end
