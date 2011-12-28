class Guest < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	validates_numericality_of :phone_number, 
														only_integer: true, greater_than: 0,
														allow_nil: true,
														message: "should be a number"

	has_many :trips

	before_destroy :ensure_not_referenced_by_trip

	def ensure_not_referenced_by_trip
		if trips.empty?
			return true
		else
			errors.add(:base, 'This guest has trips')
			return false
		end
	end

end
