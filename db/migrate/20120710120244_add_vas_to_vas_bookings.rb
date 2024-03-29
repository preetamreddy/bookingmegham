class AddVasToVasBookings < ActiveRecord::Migration
  def up
    add_column :vas_bookings, :vas, :text

		VasBooking.all.each do |vas_booking|
			vas = ValueAddedService.find(vas_booking.value_added_service_id)
			vas_booking.update_column(:vas, vas.name)
		end
  end
  def down
    remove_column :vas_bookings, :vas
  end
end
