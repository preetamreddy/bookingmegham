class AddTourOperatorServiceTaxRateToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :tour_operator_service_tax_rate, :float, default: 0.0
  end
end
