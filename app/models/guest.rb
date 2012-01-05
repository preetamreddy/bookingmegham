class Guest < ActiveRecord::Base
	has_many :trips

	before_destroy :ensure_not_referenced_by_trip

	validates :name, :phone_number, :email_id, 
						presence: true, :uniqueness => { :case_sensitive => false }

	validates_numericality_of :phone_number, 
														allow_nil: true,
														only_integer: true, greater_than: 0,
														message: "should be a number"

	private

		def ensure_not_referenced_by_trip
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because guest '#{name}' has trips. Please destroy the trips first.")
				return false
			end
		end
end
