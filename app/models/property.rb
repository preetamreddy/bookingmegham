class Property < ActiveRecord::Base
	belongs_to :agency

	has_many :room_types

	has_many :value_added_services, dependent: :destroy
	accepts_nested_attributes_for :value_added_services, :reject_if => :all_blank,
		:allow_destroy => true

	before_save :titleize, :set_defaults_if_nil

	before_destroy 	:ensure_does_not_have_room_types,
									:ensure_does_not_have_value_added_services
	
	validates :name, presence: true, :uniqueness => { :case_sensitive => false }

	validates_numericality_of :price_for_children_between_5_and_12_years,
														:price_for_children_below_5_years,
														:price_for_triple_occupancy,
														:price_for_driver,
														allow_nil: true, only_integer: true,
														greater_than_or_equal_to: 0,
														message: "should be a number greater than or equal to 0"

	validates :phone_number, :phone_number_2, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }
	
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
	
		def set_defaults_if_nil
			self.price_for_children_below_5_years ||= 0	
			self.price_for_children_between_5_and_12_years ||= 0	
			self.price_for_triple_occupancy ||= 0	
			self.price_for_driver ||= 0	
		end
	
		def ensure_does_not_have_room_types
			if room_types.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Room Types")
				return false
			end
		end

		def ensure_does_not_have_value_added_services
			if value_added_services.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Value Added Services")
				return false
			end
		end

		def titleize
			self.name = name.titleize 
		end
end
