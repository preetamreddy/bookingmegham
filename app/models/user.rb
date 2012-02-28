class User < ActiveRecord::Base
	belongs_to :advisor

	belongs_to :agency

	after_destroy :ensure_ezbook_users_are_not_deleted

	validates :name, presence: true, uniqueness: true

	has_secure_password

	private

		def ensure_ezbook_users_are_not_deleted
			if agency.name == 'EZBook'
				raise "Can't delete EZBook user"
			end
		end
end
