class AddCheckInDateCheckOutDateToRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :check_in_date, :date
    add_column :rooms, :check_out_date, :date

		Room.all.each do |room|
			if room.booking_id
				room.update_column(:check_in_date, room.booking.check_in_date)
				room.update_column(:check_out_date, room.booking.check_out_date)
			end
		end
  end

	def down
    remove_column :rooms, :check_in_date
    remove_column :rooms, :check_out_date
	end
end
