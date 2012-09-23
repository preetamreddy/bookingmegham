class RemoveBookingIdFromLineItems < ActiveRecord::Migration
  def up
    remove_column :line_items, :booking_id
  end

  def down
    add_column :line_items, :booking_id, :integer
  end
end
