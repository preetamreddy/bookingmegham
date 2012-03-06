class AddGettingHomeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :getting_home, :text
  end
end
