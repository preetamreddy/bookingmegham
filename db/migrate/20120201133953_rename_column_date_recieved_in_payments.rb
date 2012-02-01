class RenameColumnDateRecievedInPayments < ActiveRecord::Migration
  def up
		rename_column :payments, :date_recieved, :date_received
  end

  def down
		rename_column :payments, :date_received, :date_recieved
  end
end
