class AddBanjaraLuxuryTaxToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :banjara_luxury_tax, :integer, :default => 0
  end
end
