class RemoveOperatesTaxisFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :operates_taxis
  end

  def down
    remove_column :agencies, :operates_taxis, :integer, :default => 0
  end
end
