class AddNumberOfDriversToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_drivers, :integer, :default => 0
  end
end
