class AddShortNameToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :short_name, :string
  end
end
