class Agency < ActiveRecord::Base
	has_many :properties

	has_many :trips

	has_many :advisors

	has_many :users

	before_save :titleize

	before_destroy 	:ensure_does_not_have_advisors, :ensure_does_not_have_trips,
									:ensure_does_not_have_properties, :ensure_does_not_have_taxis	

	validates :phone_number, :format => { :with => /^[\+]?[\d\s]{8,}$/,
		:message => "is not valid" }

	private

		def ensure_does_not_have_advisors
			if advisors.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has advisors")
				return false
			end
		end

		def ensure_does_not_have_trips
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Trips")
				return false
			end
		end

		def ensure_does_not_have_properties
			if properties.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has properties")
				return false
			end
		end

		def ensure_does_not_have_taxis
			if taxis.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has taxis")
				return false
			end
		end

		def titleize
			self.name = name.titleize
			self.city = city.titleize
		end
	
end
