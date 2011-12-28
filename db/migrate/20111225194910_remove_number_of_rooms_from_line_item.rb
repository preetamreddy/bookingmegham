class RemoveNumberOfRoomsFromLineItem < ActiveRecord::Migration
  def up
    remove_column :line_items, :number_of_rooms
  end

  def down
    add_column :line_items, :number_of_rooms, :integer
  end
end
