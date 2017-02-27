class AddVatAndLuxuryTaxToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :vat, :integer, :default => 0
    add_column :trips, :luxury_tax, :integer, :default => 0
  end
end
