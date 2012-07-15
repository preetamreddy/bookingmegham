class Guest < ActiveRecord::Base
	TITLE = [ "Mr", "Ms", "Mrs", "Dr." ]

	belongs_to :agency

	has_many :trips

	before_save :titleize, :strip_whitespaces

	before_destroy :ensure_not_referenced_by_trip

	validates :name, presence: true

	validates_uniqueness_of :phone_number, :email_id, :scope => :account_id,
		:allow_nil => true, :allow_blank => true, :case_sensitive => false

	validates :phone_number, :phone_number_2, allow_nil: true,
		:format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

	def name_with_title
		title != "" ? "#{title} #{name}" : "#{name}"
	end

	def last_name_with_title
		title != "" ? "#{title} #{name.split.last}" : "#{name}"
	end

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
			self.resident_of = resident_of.titleize if resident_of
		end

		def strip_whitespaces
			self.other_information = other_information.to_s.strip
			self.address = address.to_s.strip
		end
end
