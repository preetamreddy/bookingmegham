class AddGstToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :cgst, :float, :default => 0.0
    add_column :rooms, :sgst, :float, :default => 0.0
  end
end
