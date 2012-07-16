class AddTotalPriceToVasBookings < ActiveRecord::Migration
  def up
    add_column :vas_bookings, :total_price, :integer

		VasBooking.all.each do |vas_booking|
			vas_booking.total_price = vas_booking.unit_price * vas_booking.number_of_units
			vas_booking.save!
		end
  end

  def down
    remove_column :vas_bookings, :total_price
  end
end
