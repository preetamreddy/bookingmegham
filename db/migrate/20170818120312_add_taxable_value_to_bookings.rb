class AddTaxableValueToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :taxable_value, :integer, :default => 0
  end
end
