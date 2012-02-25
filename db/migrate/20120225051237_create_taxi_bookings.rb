class CreateTaxiBookings < ActiveRecord::Migration
  def change
    create_table :taxi_bookings do |t|
      t.integer :trip_id
      t.integer :taxi_id
      t.integer :number_of_vehicles
      t.integer :unit_price
      t.text :remarks
      t.string :reservation_reference
      t.text :pickup_address
      t.time :pickup_time
      t.string :drop_off_city

      t.timestamps
    end
  end
end
