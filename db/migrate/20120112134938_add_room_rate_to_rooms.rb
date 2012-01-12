class AddRoomRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :room_rate, :integer
  end
end
