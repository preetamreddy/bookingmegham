class Advisor < ActiveRecord::Base
	belongs_to :agency

	has_many :trips

	has_one :user

	before_destroy :ensure_does_not_have_trips, :ensure_is_not_a_user

	private
		
		def ensure_does_not_have_trips
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because Advisor '#{name}' has trips.")
				return false
			end
		end

		def ensure_is_not_a_user
			if User.find_by_advisor_id(id)
				errors.add(:base, "Destroy failed because Advisor '#{name}' is a user.")
				return false
			else
				return true
			end
		end

end
