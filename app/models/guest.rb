class Guest < ActiveRecord::Base
	TITLE = [ "Mr", "Ms", "Mrs", "Dr." ]

	has_many :trips, :as => :customer

	validates :name, presence: true
  validates :email_id,
    :uniqueness => {:scope => :account_id, :allow_blank => true, :allow_nil => true, :case_sensitive => false},
    :email_format => true
  validates :email_id_2, :email_format => true
  validates :phone_number,
    :uniqueness => {:scope => :account_id, :allow_blank => true, :allow_nil => true, :case_sensitive => false},
    :phone_number_format => true
	validates :phone_number_2, :phone_number_format => true

	before_save :titleize, :strip_whitespaces

	before_destroy :ensure_does_not_have_trips

	def name_with_title
		title != "" ? "#{title} #{name}" : "#{name}"
	end

	def last_name_with_title
		title != "" ? "#{title} #{name.split.last}" : "#{name}"
	end

  def pan_number
    ""
  end

	private
		def titleize
			self.name = name.titleize
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
end
