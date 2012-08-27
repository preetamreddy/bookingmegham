class RenameNameToRegisteredNameInAgencies < ActiveRecord::Migration
  def up
    rename_column :agencies, :name, :registered_name
  end

  def down
    rename_column :agencies, :registered_name, :name
  end
end
