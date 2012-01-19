class CreateVasBookings < ActiveRecord::Migration
  def change
    create_table :vas_bookings do |t|
      t.integer :trip_id
      t.integer :booking_id
      t.integer :vas_id
      t.integer :unit_price
      t.integer :number_of_people
      t.integer :number_of_days
      t.text :description

      t.timestamps
    end
  end
end
