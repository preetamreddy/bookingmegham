class AddGstToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :cgst, :float, :default => 0.0
    add_column :bookings, :sgst, :float, :default => 0.0
  end
end
