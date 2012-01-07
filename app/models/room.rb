class Room < ActiveRecord::Base
	belongs_to :trip
	belongs_to :booking

	OCCUPANCY = ["Single", "Double"]	
	PEOPLE_PER_ROOM = [1, 2, 3, 4]
end
