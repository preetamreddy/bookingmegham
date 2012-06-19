class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users

end
