class AddCheckInDateCheckOutDateToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :check_in_date, :date
    add_column :bookings, :check_out_date, :date
  end
end
