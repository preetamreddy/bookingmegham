class User < ActiveRecord::Base
	belongs_to :advisor

	belongs_to :agency

	after_destroy :ensure_a_user_remains

	validates :name, presence: true, uniqueness: true
	has_secure_password

	private

		def ensure_a_user_remains
			if User.count.zero?
				raise "Can't delete last user"
			end
		end
end
