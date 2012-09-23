class Agency < ActiveRecord::Base
	has_many :trips, :as => :customer
	has_many :taxis

	validates :registered_name, :name, presence: true
  validates :email_id,
    :uniqueness => {:scope => :account_id, :allow_blank => true, :allow_nil => true, :case_sensitive => false},
    :email_format => true
  validates :email_id_2, :email_format => true
  validates :phone_number,
    :uniqueness => {:scope => :account_id, :allow_blank => true, :allow_nil => true, :case_sensitive => false},
    :phone_number_format => true
	validates :phone_number_2, :phone_number_format => true

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
				errors.add(:base, "Destroy failed because #{name} has trips")
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
