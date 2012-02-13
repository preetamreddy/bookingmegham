class Guest < ActiveRecord::Base
	has_many :trips

	before_destroy :ensure_not_referenced_by_trip

	validates :name, presence: true

	validates :phone_number, :email_id, 
						presence: true, :uniqueness => { :case_sensitive => false }

	validates :phone_number, :format => { :with => /^[\+]?[\d\s]{8,}$/,
		:message => "is not valid" }

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
