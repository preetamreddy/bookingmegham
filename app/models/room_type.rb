class RoomType < ActiveRecord::Base
	belongs_to :property

	has_many :bookings
	has_many :line_items

	before_save :ensure_property_exists

	before_destroy :ensure_does_not_have_bookings

	validates :property_id, :room_type, :number_of_rooms, presence: true
	
	validates :room_type, :uniqueness => { :case_sensitive => false }

	validates_numericality_of :number_of_rooms,
						allow_nil: true, only_integer: true,
						greater_than: 0,
						message: "should be a number greater than 0"

	validates_numericality_of :price_for_single_occupancy,
														:price_for_double_occupancy,
														allow_nil: true, only_integer: true,
														greater_than_or_equal_to: 0,
														message: "should be a number greater than or equal to 0"

	private
	
		def ensure_property_exists
			begin
				property = Property.find(property_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Room Type as Property '#{property_id}' does not exist")
				return false
			else
				return true
			end
		end

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because Room Type '#{room_type}' has bookings. Please destroy the bookings first.")
				return false
			end
		end
end
