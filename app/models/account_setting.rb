class AccountSetting < ActiveRecord::Base
  FIXED = 'Fixed'
  ADJUST = 'Adjust'

  TAX_SETTING = [FIXED, ADJUST]

  belongs_to :account

  has_many :payment_modes, dependent: :destroy
		accepts_nested_attributes_for :payment_modes, :reject_if => :all_blank,
		:allow_destroy => true

  before_validation :set_defaults_if_nil, :strip_whitespaces

	validates :account_id, :registered_name, :name, :name_abbreviation, 
    :phone_number_1, :postal_address, :url,
    presence: true
	validates :phone_number_1, :phone_number_format => true

  private
    def set_defaults_if_nil
      self.tds_percent ||= 0
      self.name_abbreviation ||= registered_name.split.collect { |w| w[0] }.join
    end

		def strip_whitespaces
			self.postal_address = postal_address.to_s.strip
		end
end
