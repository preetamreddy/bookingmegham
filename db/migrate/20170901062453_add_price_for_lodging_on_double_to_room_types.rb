class AddPriceForLodgingOnDoubleToRoomTypes < ActiveRecord::Migration
	def up
		add_column :room_types, :price_for_lodging_on_double, :integer, :default => 0

		RoomType.all.each do |room_type|
			room_type.update_column(:price_for_lodging_on_double, room_type.price_for_lodging)
		end
	end

	def down
		remove_column :room_types, :price_for_lodging_on_double
	end
end
