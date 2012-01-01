class LineItem < ActiveRecord::Base

	belongs_to :booking
	
	belongs_to :room_type

	validates :booking_id, :room_type_id, :presence => true

end
