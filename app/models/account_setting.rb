class AccountSetting < ActiveRecord::Base
  belongs_to :account

  before_validation :set_defaults_if_nil, :strip_whitespaces

	validates :registered_name, :name, :account_id, presence: true
	validates :phone_number_1,
    :format => { :with => /^[\+]?[\d\s]*$/, :message => "is not valid" }

  after_update :update_name_abbreviation

  before_destroy :return_false

  private
    def set_defaults_if_nil
      self.tds_percent ||= 10
    end

		def strip_whitespaces
			self.postal_address = postal_address.to_s.strip
		end

    def update_name_abbreviation
      self.name_abbreviation = registered_name.split.collect { |w| w[0] }.join
    end

    def return_false
      errors.add(:base, "Cannot destroy account settings")
      return false
    end
end
