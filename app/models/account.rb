class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users

	validates :name, presence: true
	validates :subdomain, :phone_number_1, :email, :url,
		presence: true, :uniqueness => { :case_sensitive => false }

	after_create :create_agency_for_account

	before_destroy :ensure_not_referenced_by_agencies

	private
		def create_agency_for_account
			Agency.create(:account_id => id,
				:name => name,
				:phone_number => phone_number_1,
				:email_id => email,
				:postal_address => postal_address,
				:url => url,
				:is_account => 1)
		end

		def ensure_not_referenced_by_agencies
			if Agency.find_all_by_account_id(id).empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has agencies")
				return false
			end
		end
end
