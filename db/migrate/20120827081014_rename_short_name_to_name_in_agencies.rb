class RenameShortNameToNameInAgencies < ActiveRecord::Migration
  def up
    rename_column :agencies, :short_name, :name
  end

  def down
    rename_column :agencies, :name, :short_name
  end
end
