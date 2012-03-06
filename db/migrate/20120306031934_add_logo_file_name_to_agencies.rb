class AddLogoFileNameToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :logo_file_name, :string
  end
end
