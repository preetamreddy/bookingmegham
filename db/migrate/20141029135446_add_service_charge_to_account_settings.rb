class AddServiceChargeToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :service_charge, :integer, :default => 0
  end
end
