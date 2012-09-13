class AddCounterToTaxiBookings < ActiveRecord::Migration
  def up
    add_column :taxi_bookings, :counter, :integer

    TaxiBooking.reset_column_information

    TaxiBooking.find(:all).each do |taxi_booking|
      taxi_booking.update_column(:counter, taxi_booking.id)
    end
  end

  def down
    remove_column :taxi_bookings, :counter
  end
end
