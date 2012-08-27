class Guest < ActiveRecord::Base
	TITLE = [ "Mr", "Ms", "Mrs", "Dr." ]

	belongs_to :agency

	has_many :trips, :as => :customer

	validates :name, presence: true
	validates_uniqueness_of :phone_number, :email_id, :scope => :account_id,
		:allow_nil => true, :allow_blank => true, :case_sensitive => false
	validates :phone_number, :phone_number_2, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

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
