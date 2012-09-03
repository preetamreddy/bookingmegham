class AddCounterToBookings < ActiveRecord::Migration
  def up
    add_column :bookings, :counter, :integer

    Booking.reset_column_information
    Trip.find(:all).each do |trip|
      counter = 1
      trip.bookings.order(:created_at).find(:all).each do |booking|
        booking.update_column(:counter, counter)
        counter += 1
      end
    end
  end

  def down
    remove_column :bookings, :counter
  end
end
