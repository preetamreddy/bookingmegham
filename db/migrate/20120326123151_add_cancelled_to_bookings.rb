class AddCancelledToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :cancelled, :integer, :default => 0
  end
end
