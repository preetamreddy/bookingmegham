class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.integer :phone_number
      t.string :email_id
      t.string :resident_of
      t.text :other_information

      t.timestamps
    end
  end
end
