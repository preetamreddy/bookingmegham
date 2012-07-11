class AddVasToVasBookings < ActiveRecord::Migration
  def up
    add_column :vas_bookings, :vas, :text

		VasBooking.all.each do |vas_booking|
			vas_booking.vas = vas_booking.value_added_service.name
			vas_booking.save!
		end
  end
  def down
    remove_column :vas_bookings, :vas
  end
end
