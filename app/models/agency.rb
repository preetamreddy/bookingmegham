class Agency < ActiveRecord::Base
	has_many :properties
	has_many :guests
	has_many :trips
	has_many :advisors
	has_many :users
	has_many :taxis

	before_save :set_defaults_if_nil, :titleize, :strip_whitespaces

	before_destroy 	:ensure_does_not_have_trips,
									:ensure_does_not_have_properties, :ensure_does_not_have_taxis,
									:ensure_does_not_have_guests,
									:ensure_is_not_an_account

	validates :name, presence: true

	validates_uniqueness_of :email_id, :phone_number, :scope => :account_id, 
		:allow_nil => true, :allow_blank => true, :case_sensitive => false

	validates :phone_number, :format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	private

		def set_defaults_if_nil
			if read_attribute(:short_name) == ""
				write_attribute(:short_name, read_attribute(:name))
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

		def ensure_does_not_have_guests
			if guests.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has guests")
				return false
			end
		end

		def ensure_is_not_an_account
			if is_account == 1
				errors.add(:base, "Destroy failed because this is the default agency")
				return false
			else
				return true
			end
		end

		def titleize
			self.city = city.titleize
			self.short_name = short_name.titleize
		end

		def strip_whitespaces
			self.postal_address = postal_address.to_s.strip
		end

end
