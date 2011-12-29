class AddNumberOfDriversToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_drivers, :integer
  end
end
