class AddHsnCodesToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :hsn_for_lodging, :string
    add_column :account_settings, :hsn_for_food, :string
    add_column :account_settings, :hsn_for_transportation, :string
    add_column :account_settings, :hsn_for_guide_services, :string
  end
end
