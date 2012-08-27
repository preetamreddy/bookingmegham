class Property < ActiveRecord::Base
	has_many :room_types
	has_many :bookings

	validates_uniqueness_of :name, :scope => :account_id, :case_sensitive => false
	validates :url, :name, presence: true
	validates_numericality_of :price_for_driver,
														allow_nil: true, only_integer: true,
														greater_than_or_equal_to: 0,
														message: "should be a number greater than or equal to 0"
	validates :phone_number, :phone_number_2, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }
	
	before_save :titleize, :set_defaults_if_nil,
							:strip_whitespaces

	before_destroy 	:ensure_does_not_have_room_types,
    :ensure_does_not_have_bookings

	def number_of_rooms
		number_of_rooms = room_types.to_a.sum { |room_type| 
												room_type.number_of_rooms }
		return number_of_rooms
	end	

	def available_rooms(date)
		room_types.to_a.sum { |room_type| room_type.available_rooms(date) }
	end

	private
		def titleize
			self.name = name.titleize 
		end

		def set_defaults_if_nil
			self.price_for_driver ||= 0	
		end
	
		def strip_whitespaces
			self.address = address.to_s.strip
			self.suggested_activities = suggested_activities.to_s.strip
		end
	
		def ensure_does_not_have_room_types
			if room_types.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Room Types")
				return false
			end
		end

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Bookings")
				return false
			end
		end
end
