class RemoveServiceTaxFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :service_tax
  end

  def down
    add_column :agencies, :service_tax, :text
  end
end
