class Room < ActiveRecord::Base
	ROOM_OCCUPANCY_TYPES = [ "Single", "Double" ]

	belongs_to :trip
	belongs_to :booking

	before_validation :set_defaults_if_nil

	validates :occupancy, :number_of_adults, :number_of_rooms, presence: true

	validates :occupancy, inclusion: ROOM_OCCUPANCY_TYPES

	validates :number_of_adults, allow_nil: true,
		:inclusion => { :in => [1, 2, 3, 4],
		:message => "%{value} is not a valid option for number of adults / room" }

	validates_numericality_of :number_of_rooms,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: "%{value} should be a number greater than 0"

	validates :number_of_children_between_5_and_12_years, allow_nil: true,
		:inclusion => { :in => [0, 1, 2, 3],
		:message => "%{value} is not a valid option for number of children / room" }

	def set_defaults_if_nil
		self.number_of_children_between_5_and_12_years ||= 0
	end

	def total_price
		room_rate * number_of_rooms * booking.number_of_nights
	end

end
