class AddTotalPriceAndServiceTaxToRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :total_price, :integer
    add_column :rooms, :service_tax, :integer

		Room.all.each do |room|
			if room.booking_id != nil
				room.update_column(:total_price,
					(room.room_rate * room.number_of_rooms * room.booking.number_of_nights))
				room.update_column(:service_tax, 
					(room.service_tax_per_room_night * room.number_of_rooms * room.booking.number_of_nights))
			end
		end
  end

	def down
    remove_column :rooms, :total_price
    remove_column :rooms, :service_tax
	end
end
