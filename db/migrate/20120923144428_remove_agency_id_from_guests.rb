class RemoveAgencyIdFromGuests < ActiveRecord::Migration
  def up
    remove_column :guests, :agency_id
  end

  def down
    add_column :guests, :agency_id, :integer
  end
end
