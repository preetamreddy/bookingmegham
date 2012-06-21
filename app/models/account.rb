class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users

	validates :name, presence: true
	validates :subdomain, :phone_number_1, :email, :url,
		presence: true, :uniqueness => { :case_sensitive => false }
end
