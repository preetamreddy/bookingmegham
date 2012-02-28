class AddEndDateToTrekBookings < ActiveRecord::Migration
  def change
    add_column :trek_bookings, :end_date, :date
  end
end
