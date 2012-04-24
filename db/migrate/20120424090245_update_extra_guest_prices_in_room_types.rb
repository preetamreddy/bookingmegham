class UpdateExtraGuestPricesInRoomTypes < ActiveRecord::Migration
  def up
		RoomType.all.each do |room_type|
			room_type.price_for_triple_occupancy = room_type.property.price_for_triple_occupancy
			room_type.price_for_children_between_5_and_12_years = room_type.property.price_for_children_between_5_and_12_years
			room_type.price_for_children_below_5_years = room_type.property.price_for_children_below_5_years
			room_type.save
		end
  end

  def down
		RoomType.all.each do |room_type|
			room_type.price_for_triple_occupancy = 0
			room_type.price_for_children_between_5_and_12_years = 0
			room_type.price_for_children_below_5_years = 0
			room_type.save
		end
  end
end
