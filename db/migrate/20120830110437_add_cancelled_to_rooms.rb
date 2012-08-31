class AddCancelledToRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :cancelled, :integer, :default => 0

    Room.all.each do |room|
      room.update_column(:cancelled, room.booking.cancelled)
    end
  end

  def down
    remove_column :rooms, :cancelled
  end
end
