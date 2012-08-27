class Advisor < ActiveRecord::Base
	belongs_to :account

	has_many :trips
	has_one :user

	validates :name, presence: true
	validates :email_id, presence: true, :uniqueness => { :case_sensitive => false }
	validates :phone_number_1, :phone_number_2, 
		:format => { :with => /^[\+]?[\d\s]*$/,
		:message => "is not valid" }

	before_save :titleize

	before_destroy :ensure_does_not_have_trips,
    :ensure_is_not_a_user

	private
		def titleize
			self.name = name.titleize
		end
		
		def ensure_does_not_have_trips
			if trips.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has trips")
				return false
			end
		end

		def ensure_is_not_a_user
			if User.find_by_advisor_id(id)
				errors.add(:base, "Destroy failed because #{name} is a user")
				return false
			else
				return true
			end
		end
end
