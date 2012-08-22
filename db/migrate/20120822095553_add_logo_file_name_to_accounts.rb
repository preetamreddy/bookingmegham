class AddLogoFileNameToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :logo_file_name, :string

    Account.all.each do |account|
      own_agency = Agency.find_by_account_id_and_is_account(account.id, 1)
      account.update_column(:logo_file_name, own_agency.logo_file_name)
    end
  end

  def down
    remove_column :accounts, :logo_file_name
  end
end
