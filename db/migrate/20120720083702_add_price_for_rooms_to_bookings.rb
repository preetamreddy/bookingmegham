class AddPriceForRoomsToBookings < ActiveRecord::Migration
  def up
    add_column :bookings, :price_for_rooms, :integer, :default => 0

		Booking.all.each do |booking|
			if booking.rooms.any?
				booking.update_column(:price_for_rooms, 
					booking.rooms.to_a.sum { |room| room.total_price } )
			end
		end
  end

	def down
    remove_column :bookings, :price_for_rooms
	end
end
