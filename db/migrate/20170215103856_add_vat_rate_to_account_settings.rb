class AddVatRateToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :vat_rate, :float, default: 0.0
  end
end
