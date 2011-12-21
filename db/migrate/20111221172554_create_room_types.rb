class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.integer :property_id
      t.string :room_type
      t.integer :price_for_single_occupancy
      t.integer :price_for_double_occupancy
      t.text :description

      t.timestamps
    end
  end
end
