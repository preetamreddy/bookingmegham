class RemoveCancelledCancellationChargeFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :cancelled
    remove_column :bookings, :cancellation_charge
  end

  def down
    add_column :bookings, :cancelled, :integer, :default => 0
    add_column :bookings, :cancellation_charge, :integer, :default => 0
  end
end
