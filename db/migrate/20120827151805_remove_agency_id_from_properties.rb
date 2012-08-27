class RemoveAgencyIdFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :agency_id
  end

  def down
    add_column :properties, :agency_id, :integer
  end
end
