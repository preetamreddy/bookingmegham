class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :guest_id
      t.date :start_date
      t.date :end_date
      t.integer :number_of_rooms
      t.integer :number_of_adults
      t.integer :number_of_children_between_5_and_12_years
      t.integer :number_of_children_below_5_years
      t.string :food_preferences
      t.integer :total_price
      t.integer :paid
      t.integer :balance_payment
      t.date :pay_by_date
      t.text :comments

      t.timestamps
    end
  end
end
