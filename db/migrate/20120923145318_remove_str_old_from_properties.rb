class RemoveStrOldFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :str_old
  end

  def down
    add_column :properties, :str_old, :string, :default => "0"
  end
end
