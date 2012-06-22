class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users

	validates :name, presence: true
	validates :subdomain, :phone_number_1, :email, :url,
		presence: true, :uniqueness => { :case_sensitive => false }

	after_create :create_agency_for_account

	private
		def create_agency_for_account
			Agency.create(:account_id => id,
				:name => name,
				:phone_number => phone_number,
				:email_id => email_id,
				:postal_address => postal_address,
				:url => url,
				:is_account => 1)
		end
end
