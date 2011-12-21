class AddNumberOfRoomsToRoomType < ActiveRecord::Migration
  def change
    add_column :room_types, :number_of_rooms, :integer
  end
end
