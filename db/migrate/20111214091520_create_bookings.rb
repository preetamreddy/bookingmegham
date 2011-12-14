class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :guest_name
      t.integer :guest_phone_number
      t.string :guest_email_id
      t.integer :number_of_rooms
      t.date :from
      t.date :to
      t.integer :number_of_adults
      t.integer :number_of_children
      t.integer :number_of_infants
      t.time :guests_arrival_time
      t.string :guests_arriving_from
      t.string :guests_food_preferences
      t.integer :total_price
      t.integer :paid
      t.integer :balance_payment
      t.date :pay_by_date
      t.text :comments

      t.timestamps
    end
  end
end
