class AddOperatesPropertiesToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :operates_properties, :integer, :default => 1
  end
end
