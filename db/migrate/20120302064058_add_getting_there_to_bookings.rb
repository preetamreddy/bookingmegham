class AddGettingThereToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :getting_there, :text
  end
end
