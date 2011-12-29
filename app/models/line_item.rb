class LineItem < ActiveRecord::Base

	belongs_to :booking
	
	belongs_to :room_type

end
