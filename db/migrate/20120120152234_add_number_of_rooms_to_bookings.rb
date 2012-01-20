class AddNumberOfRoomsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_rooms, :integer
  end
end
