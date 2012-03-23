class AddDirectBookingToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :direct_booking, :integer, :default => 1
  end
end
