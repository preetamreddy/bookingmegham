class AddIgstToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :igst, :float, :default => 0.0
  end
end
