class AddStartDateAndNumberOfDaysAndEndDateToTaxiBookings < ActiveRecord::Migration
  def change
    add_column :taxi_bookings, :start_date, :date
    add_column :taxi_bookings, :number_of_days, :integer
    add_column :taxi_bookings, :end_date, :date
  end
end
