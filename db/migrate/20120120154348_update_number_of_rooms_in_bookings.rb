class UpdateNumberOfRoomsInBookings < ActiveRecord::Migration
  def up
		Booking.all.each do |booking|
			booking.update_number_of_rooms
			booking.save!
		end
  end

	def down
		Booking.all.each do |booking|
			booking.number_of_rooms = nil
			booking.save!
		end
	end
end
