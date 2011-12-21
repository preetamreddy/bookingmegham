class CreateBookedRooms < ActiveRecord::Migration
  def change
    create_table :booked_rooms do |t|
      t.integer :room_type_id
      t.date :for_date
      t.integer :count

      t.timestamps
    end
  end
end
