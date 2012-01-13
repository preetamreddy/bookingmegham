class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :trip_id
      t.date :date_recieved
      t.integer :amount
      t.string :details

      t.timestamps
    end
  end
end
