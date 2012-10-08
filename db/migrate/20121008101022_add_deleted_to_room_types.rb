class AddDeletedToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :deleted, :integer, :default => 0
  end
end
