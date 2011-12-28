class Trip < ActiveRecord::Base
	validates :guest_id, :start_date, :end_date, :number_of_rooms,
						:number_of_adults, :number_of_children_between_5_and_12_years,
						:number_of_children_below_5_years,
						presence: true
	validates_numericality_of :guest_id, :number_of_rooms,
						:number_of_adults,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_between_5_and_12_years,
						:number_of_children_below_5_years,
						only_integer: true, greater_than_or_equal_to: 0, allow_nil: true,
						message: "should be a positive number or 0"

	belongs_to :guest

	has_many :bookings

	before_destroy :ensure_not_referenced_by_booking

	def ensure_not_referenced_by_booking
		if bookings.empty?
			return true
		else
			errors.add(:base, 'This trip has bookings')
			return false
		end
	end

end
