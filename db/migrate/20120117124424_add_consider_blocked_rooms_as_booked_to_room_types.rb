class AddConsiderBlockedRoomsAsBookedToRoomTypes < ActiveRecord::Migration
  def change
		add_column :room_types, :consider_blocked_rooms_as_booked, :integer, :default => 1
  end
end
