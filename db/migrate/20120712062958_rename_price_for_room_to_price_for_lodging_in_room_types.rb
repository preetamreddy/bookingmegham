class RenamePriceForRoomToPriceForLodgingInRoomTypes < ActiveRecord::Migration
  def up
		rename_column :room_types, :price_for_room, :price_for_lodging
  end

  def down
		rename_column :room_types, :price_for_lodging, :price_for_room
  end
end
