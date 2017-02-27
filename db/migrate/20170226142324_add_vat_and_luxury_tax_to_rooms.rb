class AddVatAndLuxuryTaxToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :vat, :integer, :default => 0
    add_column :rooms, :luxury_tax, :integer, :default => 0
  end
end
