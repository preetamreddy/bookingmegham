class Advisor < ActiveRecord::Base
	belongs_to :agency

	has_many :trips

	has_one :user

end
