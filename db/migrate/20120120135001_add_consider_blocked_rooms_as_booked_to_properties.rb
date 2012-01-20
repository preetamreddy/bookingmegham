class AddConsiderBlockedRoomsAsBookedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :consider_blocked_rooms_as_booked, :integer, :default => 1
  end
end
