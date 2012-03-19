class AddAgencyIdToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :agency_id, :integer
  end
end
