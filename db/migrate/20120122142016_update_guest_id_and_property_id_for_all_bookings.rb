class UpdateGuestIdAndPropertyIdForAllBookings < ActiveRecord::Migration
  def up
		Booking.all.each do |booking|
			booking.guest_id = booking.trip.guest_id
			booking.property_id = booking.room_type.property_id
			booking.save!
		end
  end

  def down
		Booking.all.each do |booking|
			booking.guest_id = nil
			booking.property_id = nil
			booking.save!
		end
  end
end
