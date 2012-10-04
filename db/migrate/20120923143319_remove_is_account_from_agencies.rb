class RemoveIsAccountFromAgencies < ActiveRecord::Migration
  def up
    Agency.find(:all, :conditions => [ 'is_account = ?', 1 ]).each do |agency|
      agency.destroy
    end

    remove_column :agencies, :is_account
  end

  def down
    add_column :agencies, :is_account, :integer, :default => 0
  end
end
