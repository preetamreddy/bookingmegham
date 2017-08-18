class AddGstToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :cgst, :float, :default => 0.0
    add_column :vas_bookings, :sgst, :float, :default => 0.0
  end
end
