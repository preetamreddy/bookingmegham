class AddNumberOfNightsToRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :number_of_nights, :integer

		Room.all.each do |room|
			if room.booking_id
				room.update_column(:number_of_nights, room.booking.number_of_nights)
			end
		end
  end

	def down
    remove_column :rooms, :number_of_nights
	end
end
