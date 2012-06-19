class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :subdomain
      t.string :phone_number_1
      t.string :email
      t.text :postal_address
      t.string :url

      t.timestamps
    end
  end
end
