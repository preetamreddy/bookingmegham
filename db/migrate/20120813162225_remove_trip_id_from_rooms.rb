class RemoveTripIdFromRooms < ActiveRecord::Migration
  def up
		remove_column :rooms, :trip_id
  end

  def down
		add_column :rooms, :trip_id, :integer
  end
end
