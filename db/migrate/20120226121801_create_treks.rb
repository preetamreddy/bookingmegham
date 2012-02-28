class CreateTreks < ActiveRecord::Migration
  def change
    create_table :treks do |t|
      t.string :name
      t.text :itinerary
      t.string :difficulty
      t.integer :number_of_days

      t.timestamps
    end
  end
end
