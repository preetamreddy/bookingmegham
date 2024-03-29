class RemoveConsiderBlockedRoomsAsBookedFromRoomTypes < ActiveRecord::Migration
  def up
		remove_column :room_types, :consider_blocked_rooms_as_booked
  end

  def down
		add_column :room_types, :consider_blocked_rooms_as_booked, :integer, :default => 1
  end
end
