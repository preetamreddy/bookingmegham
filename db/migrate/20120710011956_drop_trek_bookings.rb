class DropTrekBookings < ActiveRecord::Migration
  def up
		drop_table :trek_bookings
  end

  def down
    create_table :trek_bookings do |t|
      t.integer :trip_id
      t.integer :trek_id
      t.integer :unit_price
      t.date :start_date
      t.string :origin
      t.string :final_destination
    	t.integer :number_of_days
    	t.date :end_date
    	t.integer :account_id

      t.timestamps
    end

		add_index "trek_bookings", ["account_id"], :name => "index_trek_bookings_on_account_id"
  end
end
