class AddBlockedToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :blocked, :integer, :default => 1
  end
end
