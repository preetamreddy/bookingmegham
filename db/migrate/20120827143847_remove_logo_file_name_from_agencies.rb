class RemoveLogoFileNameFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :logo_file_name
  end

  def down
    add_column :agencies, :logo_file_name, :string
  end
end
