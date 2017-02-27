class AddServiceTaxRateToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :service_tax_rate, :float, default: 0.0
  end
end
