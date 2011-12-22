class Property < ActiveRecord::Base
	has_many :room_types

	before_destroy :ensure_does_not_have_bookings
	
	validates :name, presence: true

	validates_numericality_of :price_for_children_between_5_and_12_years,
														:price_for_children_below_5_years,
														:price_for_triple_occupancy,
														:price_for_driver,
														allow_nil: true, only_integer: true,
														message: "should be a number"

	private
	
		def ensure_does_not_have_bookings
			if room_types.bookings.empty?
				return true
			else
				errors.add(:base, 'Bookings exist for this Property')
				return false
			end
		end
end
