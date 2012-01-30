class AddNumberOfNightsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_nights, :integer
  end
end
