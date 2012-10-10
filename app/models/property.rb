class Property < ActiveRecord::Base
	has_many :room_types
	has_many :bookings

	validates :name, :url, :price_for_driver, :service_tax_rate, presence: true
	validates_uniqueness_of :name, :scope => :account_id, :case_sensitive => false
	validates_numericality_of :price_for_driver,
		only_integer: true, greater_than_or_equal_to: 0,
		message: "should be a number greater than or equal to 0"
	validates_numericality_of :service_tax_rate, allow_nil: true, greater_than_or_equal_to: 0,
		message: "should be a number greater than or equal to 0"
	validates :phone_number, :phone_number_2,
		:format => { :with => /^[\+]?[\d\s]*$/, :allow_blank => true, :message => "is not valid" }
	
	before_save :titleize, :strip_whitespaces

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

	def availability(start_date, end_date, rooms_required)
		availability_status = true
		if ensure_availability_before_booking == 1
			(start_date...end_date).each do |date|
				if available_rooms(date) < rooms_required
					availability_status = false
				end
			end
		end
		
		return availability_status
	end

	private
		def titleize
			self.name = name.titleize 
		end

		def strip_whitespaces
			self.address = address.to_s.strip
			self.suggested_activities = suggested_activities.to_s.strip
		end
	
		def ensure_does_not_have_room_types
			if room_types.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has rooms")
				return false
			end
		end

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has bookings")
				return false
			end
		end
end
