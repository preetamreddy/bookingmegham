class RemoveHsnCodesFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :hsn_for_lodging
    remove_column :agencies, :hsn_for_food
    remove_column :agencies, :hsn_for_transportation
    remove_column :agencies, :hsn_for_guide_services
  end

  def down
    add_column :agencies, :hsn_for_lodging, :string
    add_column :agencies, :hsn_for_food, :string
    add_column :agencies, :hsn_for_transportation, :string
    add_column :agencies, :hsn_for_guide_services, :string
  end
end
