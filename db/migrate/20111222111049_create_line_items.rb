class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :booking_id
      t.integer :room_type_id
      t.date :date
      t.integer :number_of_rooms

      t.timestamps
    end
  end
end
