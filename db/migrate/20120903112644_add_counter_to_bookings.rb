class AddCounterToBookings < ActiveRecord::Migration
  def up
    add_column :bookings, :counter, :integer

    Booking.reset_column_information

    Booking.find(:all).each do |booking|
      booking.update_column(:counter, booking.id)
    end
  end

  def down
    remove_column :bookings, :counter
  end
end
