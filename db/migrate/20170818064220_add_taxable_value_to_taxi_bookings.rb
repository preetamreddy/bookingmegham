class AddTaxableValueToTaxiBookings < ActiveRecord::Migration
  def change
    add_column :taxi_bookings, :taxable_value, :integer, :default => 0
  end
end
