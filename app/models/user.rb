class User < ActiveRecord::Base
	belongs_to :advisor

	validates :name, presence: true, uniqueness: true
	has_secure_password

end
