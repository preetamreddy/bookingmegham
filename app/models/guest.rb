class Guest < ActiveRecord::Base
	TITLE = [ "Mr", "Ms", "Mrs" ]

	belongs_to :agency

	has_many :trips

	before_save :titleize, :strip_whitespaces

	before_destroy :ensure_not_referenced_by_trip

	validates :name, :title, presence: true

	validates :phone_number, :email_id, :allow_nil => true,
						:allow_blank => true,
						:uniqueness => { :case_sensitive => false }

	validates :phone_number, :phone_number_2, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	private

		def ensure_not_referenced_by_trip
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has trips")
				return false
			end
		end

		def titleize
			self.name = name.titleize
			self.resident_of = resident_of.titleize
		end

		def strip_whitespaces
			self.other_information = other_information.strip
			self.address = address.strip
		end
end
