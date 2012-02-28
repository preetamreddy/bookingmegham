class Agency < ActiveRecord::Base
	has_many :properties

	has_many :trips

	has_many :advisors

	has_many :users

	before_save :titleize

	before_destroy :ensure_does_not_have_advisors, :ensure_does_not_have_trips

	validates :phone_number, :format => { :with => /^[\+]?[\d\s]{8,}$/,
		:message => "is not valid" }

	private

		def ensure_does_not_have_advisors
			if advisors.empty?
				return true
			else
				errors.add(:base, "Destroy failed because Agency '#{name}' has advisors.")
				return false
			end
		end

		def ensure_does_not_have_trips
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because Agency '#{name}' has Trips.")
				return false
			end
		end

		def titleize
			self.name = name.titleize
			self.city = city.titleize
		end
	
end
