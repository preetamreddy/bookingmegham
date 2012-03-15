class AddPanNumberToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :pan_number, :string
  end
end
