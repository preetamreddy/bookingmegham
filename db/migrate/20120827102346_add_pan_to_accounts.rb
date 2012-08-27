class AddPanToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :pan, :string

    Account.all.each do |account|
      agency = Agency.find_by_account_id_and_is_account(account.id, 1)
      account.update_column(:pan, agency.pan_number)
    end
  end

  def down
    remove_column :accounts, :pan
  end
end
