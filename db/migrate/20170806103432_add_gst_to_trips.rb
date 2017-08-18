class AddGstToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :cgst, :float, :default => 0.0
    add_column :trips, :sgst, :float, :default => 0.0
  end
end
