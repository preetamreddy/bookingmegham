class AddNumberOfDaysToTrekBookings < ActiveRecord::Migration
  def change
    add_column :trek_bookings, :number_of_days, :integer
  end
end
