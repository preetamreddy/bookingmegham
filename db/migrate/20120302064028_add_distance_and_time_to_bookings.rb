class AddDistanceAndTimeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :distance_and_time, :string
  end
end
