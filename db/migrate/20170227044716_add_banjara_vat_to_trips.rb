class AddBanjaraVatToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :banjara_vat, :integer, :default => 0
  end
end
