class DropTreks < ActiveRecord::Migration
  def up
		drop_table :treks
  end

  def down
    create_table :treks do |t|
      t.string :name
      t.text :itinerary
      t.string :difficulty
      t.integer :number_of_days
			t.integer :account_id

      t.timestamps
    end

		add_index "treks", ["account_id"], :name => "index_treks_on_account_id"
  end
end
