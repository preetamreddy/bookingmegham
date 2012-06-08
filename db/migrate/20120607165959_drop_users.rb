class DropUsers < ActiveRecord::Migration
  def up
		drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.integer :advisor_id
    	t.integer :agency_id

      t.timestamps
    end
  end
end
