class CreateAdvisors < ActiveRecord::Migration
  def change
    create_table :advisors do |t|
      t.integer :agency_id
      t.string :name
      t.integer :phone_number_1
      t.integer :phone_number_2
      t.string :email_id

      t.timestamps
    end
  end
end
