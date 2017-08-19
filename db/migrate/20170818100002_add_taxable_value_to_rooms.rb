class AddTaxableValueToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :taxable_value, :integer, :default => 0
  end
end
