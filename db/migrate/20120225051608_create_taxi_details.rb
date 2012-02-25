class CreateTaxiDetails < ActiveRecord::Migration
  def change
    create_table :taxi_details do |t|
      t.integer :taxi_booking_id
      t.string :registration_number
      t.string :driver_name
      t.string :driver_phone_number
      t.text :remarks

      t.timestamps
    end
  end
end
