class TaxiDetail < ActiveRecord::Base
	belongs_to :taxi_booking

	validates :registration_number, :driver_name, :driver_phone_number,
		presence: true

	validates :driver_phone_number, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

end
