class AddHsnCodesToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :hsn_for_lodging, :string
    add_column :agencies, :hsn_for_food, :string
    add_column :agencies, :hsn_for_transportation, :string
    add_column :agencies, :hsn_for_guide_services, :string
  end
end
