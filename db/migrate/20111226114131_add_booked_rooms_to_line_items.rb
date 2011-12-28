class AddBookedRoomsToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :booked_rooms, :integer
  end
end
