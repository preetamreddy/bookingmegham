class Property < ActiveRecord::Base
	belongs_to :agency

	has_many :room_types

	has_many :value_added_services, dependent: :destroy
	accepts_nested_attributes_for :value_added_services, :reject_if => :all_blank,
		:allow_destroy => true

	before_save :titleize, :set_defaults_if_nil,
							:strip_whitespaces

	before_destroy 	:ensure_does_not_have_room_types,
									:ensure_does_not_have_value_added_services

	validates_uniqueness_of :name, :scope => :account_id, :case_sensitive => false

	validates :url, :name, presence: true
	
	validates_numericality_of :price_for_driver,
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

		def strip_whitespaces
			self.description = description.to_s.strip
			self.address = address.to_s.strip
			self.suggested_activities = suggested_activities.to_s.strip
		end
end
