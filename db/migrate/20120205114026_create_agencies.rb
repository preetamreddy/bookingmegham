class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.integer :phone_number
      t.string :email_id
      t.text :postal_address
      t.string :city
      t.string :url
      t.text :other_information

      t.timestamps
    end
  end
end
