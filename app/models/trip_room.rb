class TripRoom < ActiveRecord::Base
	ROOM_OCCUPANCY_TYPES = [ "Single", "Double" ]

	belongs_to :trip

	before_validation :set_defaults_if_nil

	validates :occupancy, :number_of_rooms, :number_of_adults, presence: true
	validates :occupancy, :inclusion => { :in => ROOM_OCCUPANCY_TYPES,
    :message => ": \"%{value}\" is not a valid option" }
	validates :number_of_adults, allow_nil: true,
		:inclusion => { :in => [1, 2, 3, 4],
		:message => ": %{value} is not a valid option" }
	validates_numericality_of :number_of_rooms,
		allow_nil: true, only_integer: true, greater_than: 0,
		message: ": %{value} should be a number greater than 0"
	validates :number_of_children_between_5_and_12_years, 
	  :number_of_children_below_5_years, allow_nil: true,
		:inclusion => { :in => [0, 1, 2, 3],
		:message => ": %{value} is not a valid option" }

	before_create :set_account_id

	def guests_per_room
		if number_of_children_between_5_and_12_years == 0
			" " + number_of_adults.to_s
		else
			" " + number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s
		end
	end

	def all_guests_per_room
		if number_of_children_between_5_and_12_years == 0 and number_of_children_below_5_years == 0
			number_of_adults.to_s
		elsif number_of_children_below_5_years == 0
			number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s
		else
			number_of_adults.to_s + "+" + number_of_children_between_5_and_12_years.to_s + "+" + number_of_children_below_5_years.to_s
		end
	end

	private
		def set_defaults_if_nil
			self.number_of_children_between_5_and_12_years ||= 0
			self.number_of_children_below_5_years ||= 0
		end

		def set_account_id
			self.account_id = trip.account_id
		end
end
