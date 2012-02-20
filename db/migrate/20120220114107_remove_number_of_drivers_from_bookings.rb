class RemoveNumberOfDriversFromBookings < ActiveRecord::Migration
  def up
		remove_column :bookings, :number_of_drivers
  end

  def down
		add_column :bookings, :number_of_drivers, :integer
  end
end
