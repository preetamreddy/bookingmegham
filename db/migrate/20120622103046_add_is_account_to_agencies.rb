class AddIsAccountToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :is_account, :integer, :default => 0
  end
end
