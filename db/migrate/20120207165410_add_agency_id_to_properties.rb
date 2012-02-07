class AddAgencyIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :agency_id, :integer
  end
end
