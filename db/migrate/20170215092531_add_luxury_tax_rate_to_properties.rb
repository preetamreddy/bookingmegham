class AddLuxuryTaxRateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :luxury_tax_rate, :float, default: 0.0
  end
end
