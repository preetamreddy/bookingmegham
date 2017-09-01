class AddIgstToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :igst, :float, :default => 0.0
  end
end
