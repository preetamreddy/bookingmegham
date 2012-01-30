class UpdateNumberOfNightsInBooking < ActiveRecord::Migration
  def up
		Booking.all.each do |booking|
			booking.number_of_nights = booking.check_out_date - booking.check_in_date
			booking.save!
		end
  end

  def down
		Booking.all.each do |booking|
			booking.number_of_nights = 0
			booking.save!
		end
  end
end
