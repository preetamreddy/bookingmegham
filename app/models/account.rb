class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users

	validates :name, presence: true
	validates :subdomain, :phone_number_1, :email, :url,
		presence: true, :uniqueness => { :case_sensitive => false }

	before_destroy :ensure_not_referenced_by_agencies,
    :ensure_not_referenced_by_guests,
    :ensure_not_referenced_by_properties,
    :ensure_not_referenced_by_advisors

	private
		def ensure_not_referenced_by_agencies
			if Agency.find_all_by_account_id(id).empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has agencies")
				return false
			end
		end

		def ensure_not_referenced_by_guests
			if Guest.find_all_by_account_id(id).empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has guests")
				return false
			end
		end

		def ensure_not_referenced_by_properties
			if Property.find_all_by_account_id(id).empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has properties")
				return false
			end
		end

		def ensure_not_referenced_by_advisors
			if Advisor.find_all_by_account_id(id).empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has advisors")
				return false
			end
		end
end
