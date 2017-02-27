class AddVatRateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :vat_rate, :float, default: 0.0
  end
end
