class AddIgstToTaxiBookings < ActiveRecord::Migration
  def change
    add_column :taxi_bookings, :igst, :float, :default => 0.0
  end
end
