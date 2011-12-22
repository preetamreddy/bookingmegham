class RoomType < ActiveRecord::Base

	belongs_to :property

	has_many :bookings

	has_many :line_items

	before_destroy :ensure_does_not_have_bookings

	validates :property_id, :room_type, :number_of_rooms, presence: true

	validates_numericality_of :price_for_single_occupancy,
														:price_for_double_occupancy, :number_of_rooms,
														allow_nil: true, only_integer: true,
														message: "should be a number"

	private

		def ensure_does_not_have_bookings
			if bookings.empty?
				return true
			else
				errors.add(:base, 'Bookings exist for this room type')
				return false
			end
		end
end
