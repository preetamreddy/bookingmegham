class AddGstinToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :gstin, :string
  end
end
