class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :occupancy
      t.integer :number_of_adults
      t.integer :number_of_children_between_5_and_12_years
      t.integer :number_of_rooms
      t.integer :trip_id
      t.integer :booking_id

      t.timestamps
    end
  end
end
