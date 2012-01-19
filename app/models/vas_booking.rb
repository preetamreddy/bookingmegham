class VasBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking
	belongs_to :value_added_service

end
