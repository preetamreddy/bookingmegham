class Account < ActiveRecord::Base
	has_many :advisors
	has_many :users
  has_one :account_setting

	validates :name, presence: true
	validates :subdomain, :phone_number_1, :email, :url,
		presence: true, :uniqueness => { :case_sensitive => false }
  validates :phone_number_1,
    :format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

  after_create :create_account_settings

	before_destroy :ensure_not_referenced_by_agencies,
    :ensure_not_referenced_by_guests,
    :ensure_not_referenced_by_properties,
    :ensure_does_not_have_advisors,
    :ensure_does_not_have_users

	private
    def create_account_settings
      AccountSetting.create(:registered_name => name,
                            :name => name,
                            :phone_number_1 => phone_number_1,
                            :email => email,
                            :postal_address => postal_address,
                            :url => url,
                            :account_id => id)
    end

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

		def ensure_does_not_have_advisors
			if advisors.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has advisors")
				return false
			end
		end

		def ensure_does_not_have_users
			if users.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has users")
				return false
			end
		end
end
