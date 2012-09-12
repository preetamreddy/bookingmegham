class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.integer :room_type_id
      t.integer :account_id
      t.integer :price_for_single_occupancy
      t.integer :price_for_double_occupancy
      t.integer :price_for_extra_adults
      t.integer :price_for_children
      t.integer :price_for_infants
      t.string :meal_plan
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
