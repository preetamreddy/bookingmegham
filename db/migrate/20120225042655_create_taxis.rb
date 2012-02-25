class CreateTaxis < ActiveRecord::Migration
  def change
    create_table :taxis do |t|
      t.integer :agency_id
      t.string :model
      t.integer :max_passengers
      t.integer :unit_price
      t.text :terrain_limitations

      t.timestamps
    end
  end
end
