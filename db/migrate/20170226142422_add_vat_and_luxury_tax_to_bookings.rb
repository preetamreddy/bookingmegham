class AddVatAndLuxuryTaxToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :vat, :integer, :default => 0
    add_column :bookings, :luxury_tax, :integer, :default => 0
  end
end
