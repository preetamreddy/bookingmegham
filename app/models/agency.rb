class Agency < ActiveRecord::Base
	has_many :properties

	has_many :guests

	has_many :trips

	has_many :advisors

	has_many :users

	has_many :taxis

	before_save :titleize, :strip_whitespaces,
							:set_defaults_if_nil

	before_destroy 	:ensure_does_not_have_advisors, :ensure_does_not_have_trips,
									:ensure_does_not_have_properties, :ensure_does_not_have_taxis	

	validates :name, presence: true

	validates :phone_number, :email_id, :allow_nil => true,
		:allow_blank => true,
		:uniqueness => { :case_sensitive => false }

	validates :phone_number, :format => { :with => /^[\+]?[\d\s]*$/,
		:message => "is not valid" }

	private

		def set_defaults_if_nil
			if read_attribute(:short_name) == "" or read_attribute(:short_name) == nil
				write_attribute(:short_name, read_attribute(:name))
			end
		end

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
			self.city = city.titleize
		end

		def strip_whitespaces
			self.postal_address = postal_address.strip
		end
	
end
