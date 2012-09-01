class Agency < ActiveRecord::Base
	has_many :trips, :as => :customer
	has_many :taxis
	has_many :guests

	validates :name, presence: true
	validates_uniqueness_of :email_id, :phone_number, :phone_number_2, :scope => :account_id, 
		:allow_nil => true, :allow_blank => true, :case_sensitive => false
	validates :phone_number, :phone_number_2,
    :format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	before_save :titleize, :strip_whitespaces

	before_destroy 	:ensure_does_not_have_trips,
									:ensure_does_not_have_taxis,
									:ensure_does_not_have_guests

  def title
    ""
  end

  def name_with_title
    registered_name
  end

  def last_name_with_title
    registered_name
  end

	private
		def titleize
			self.city = city.titleize if city
		end

		def strip_whitespaces
			self.postal_address = postal_address.to_s.strip
		end

		def ensure_does_not_have_trips
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has Trips")
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
end
