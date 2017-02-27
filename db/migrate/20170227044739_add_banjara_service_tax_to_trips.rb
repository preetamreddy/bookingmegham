class AddBanjaraServiceTaxToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :banjara_service_tax, :integer, :default => 0
  end
end
