class Guest < ActiveRecord::Base
	validates :name, presence: true, :uniqueness => { :case_sensitive => false }
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
			errors.add(:base, "Destroy failed because guest '#{name}' has trips")
			return false
		end
	end

end
