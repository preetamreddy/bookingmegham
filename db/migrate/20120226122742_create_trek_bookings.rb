class CreateTrekBookings < ActiveRecord::Migration
  def change
    create_table :trek_bookings do |t|
      t.integer :trip_id
      t.integer :trek_id
      t.integer :unit_price
      t.date :start_date
      t.string :origin
      t.string :final_destination

      t.timestamps
    end
  end
end
