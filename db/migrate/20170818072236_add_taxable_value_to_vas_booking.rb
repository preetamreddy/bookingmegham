class AddTaxableValueToVasBooking < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :taxable_value, :integer, :default => 0
  end
end
