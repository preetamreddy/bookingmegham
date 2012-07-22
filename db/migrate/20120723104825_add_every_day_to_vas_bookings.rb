class AddEveryDayToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :every_day, :integer, :default => 0
  end
end
