class Agency < ActiveRecord::Base
	has_many :trips

	has_many :advisors
	
end
