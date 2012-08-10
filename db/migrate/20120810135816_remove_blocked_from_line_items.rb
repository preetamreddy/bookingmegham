class RemoveBlockedFromLineItems < ActiveRecord::Migration
  def up
		remove_column :line_items, :blocked
  end

  def down
		add_column :line_items, :blocked, :integer, :default => 1
  end
end
