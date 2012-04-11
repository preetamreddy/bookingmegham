class UpdateServiceTaxRetroactivelyFor2012 < ActiveRecord::Migration
  def up
		Room.all.each do |room|
			if room.booking_id != nil
				room.service_tax_rate = RoomType.find(room.booking.room_type_id).service_tax
				room.save
			end
		end

		update_service_tax_for_all_existing_bookings
  end

  def down
		Room.all.each do |room|
			if room.booking_id != nil
				room.service_tax_rate = RoomType.find(room.booking.room_type_id).service_tax * 5.15 / 6.18
				room.save
			end
		end

		update_service_tax_for_all_existing_bookings
  end

	def update_service_tax_for_all_existing_bookings
		Booking.all.each do |booking|
			if booking.rooms.any?
				service_tax_per_night = booking.rooms.to_a.sum { |room|
					room.service_tax_rate * room.number_of_rooms }
			else
				service_tax_per_night = 0
			end

			booking.service_tax = booking.number_of_nights * service_tax_per_night
			booking.save
		end
	end
end
