class AddOperatesTaxisToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :operates_taxis, :integer, :default => 0
  end
end
