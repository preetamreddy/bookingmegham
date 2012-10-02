class RemoveNumberOfRoomsFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :number_of_rooms
  end

  def down
    add_column :bookings, :number_of_rooms, :integer
  end
end
