class AddEzbookColsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agency_id, :integer
    add_column :users, :advisor_id, :integer
    add_column :users, :name, :string
  end
end
