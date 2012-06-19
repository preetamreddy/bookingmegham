class RemoveAgencyIdFromUsers < ActiveRecord::Migration
  def up
		remove_column :users, :agency_id
  end

  def down
		add_column :users, :agency_id, :integer
  end
end
