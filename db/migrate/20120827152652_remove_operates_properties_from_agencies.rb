class RemoveOperatesPropertiesFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :operates_properties
  end

  def down
    add_column :agencies, :operates_properties, :integer
  end
end
