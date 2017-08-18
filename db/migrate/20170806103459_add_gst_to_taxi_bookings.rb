class AddGstToTaxiBookings < ActiveRecord::Migration
  def change
    add_column :taxi_bookings, :cgst, :float, :default => 0.0
    add_column :taxi_bookings, :sgst, :float, :default => 0.0
  end
end
