class RemoveItineraryColumnsFromBookings < ActiveRecord::Migration
  def up
		Booking.all.each do |booking|
			if booking.distance_and_time != "" and booking.distance_and_time != nil
				booking.update_column(:remarks, booking.remarks + booking.distance_and_time)
			end
			if booking.getting_there != "" and booking.getting_there != nil
				booking.update_column(:remarks, booking.remarks + booking.getting_there)
			end
			if booking.getting_home != "" and booking.getting_home != nil
				booking.update_column(:remarks, booking.remarks + booking.getting_home)
			end
		end

		remove_column :bookings, :distance_and_time
		remove_column :bookings, :getting_there
		remove_column :bookings, :getting_home
		remove_column :bookings, :suggested_activities
  end

  def down
		add_column :bookings, :distance_and_time, :string
		add_column :bookings, :getting_there, :text
		add_column :bookings, :getting_home, :text
		add_column :bookings, :suggested_activities, :text
  end
end
