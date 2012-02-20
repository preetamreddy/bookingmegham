class AddDepartureDestinationToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :departure_destination, :string
  end
end
