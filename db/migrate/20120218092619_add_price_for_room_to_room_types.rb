class AddPriceForRoomToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :price_for_room, :integer
  end
end
