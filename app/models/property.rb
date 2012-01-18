class Property < ActiveRecord::Base
	has_many :room_types

	has_many :value_added_services, dependent: :destroy
	accepts_nested_attributes_for :value_added_services, :reject_if => :all_blank,
		:allow_destroy => true

	before_destroy :ensure_does_not_have_room_types
	
	validates :name, presence: true, :uniqueness => { :case_sensitive => false }

	validates_numericality_of :price_for_children_between_5_and_12_years,
														:price_for_children_below_5_years,
														:price_for_triple_occupancy,
														:price_for_driver,
														allow_nil: true, only_integer: true,
														greater_than_or_equal_to: 0,
														message: "should be a number greater than or equal to 0"
	
	def number_of_rooms
		number_of_rooms = room_types.to_a.sum { |room_type| 
												room_type.number_of_rooms }
		return number_of_rooms
	end	

	def available_rooms(date, consider_blocked_rooms_as_booked)
		room_types.to_a.sum { |room_type| 
			room_type.available_rooms(date, consider_blocked_rooms_as_booked) }
	end

	private
	
		def ensure_does_not_have_room_types
			if room_types.empty?
				return true
			else
				errors.add(:base, "Destroy failed because the property '#{name}' has Room Types. Please destroy the Room Types first.")
				return false
			end
		end
end
