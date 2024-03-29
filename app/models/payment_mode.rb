class PaymentMode < ActiveRecord::Base
  belongs_to :account_setting

  validates :name, :presence => true

  before_create :set_account_id

  private
    def set_account_id
      self.account_id = account_setting.account_id
    end
end
