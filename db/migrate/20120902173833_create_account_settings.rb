class CreateAccountSettings < ActiveRecord::Migration
  def up
    create_table :account_settings do |t|
      t.string :registered_name
      t.string :name
      t.string :name_abbreviation
      t.string :phone_number_1
      t.string :email
      t.text :postal_address
      t.string :url
      t.string :pan
      t.string :service_tax_number
      t.integer :tds_percent
      t.integer :account_id

      t.timestamps
    end

    add_index "account_settings", ["account_id"], :name => "index_account_settings_on_account_id"

    Account.all.each do |account|
      AccountSetting.create(:registered_name => account.name,
                            :name => account.name,
                            :phone_number_1 => account.phone_number_1,
                            :email => account.email,
                            :postal_address => account.postal_address,
                            :url => account.url,
                            :pan => account.pan,
                            :account_id => account.id)
    end
  end

  def down
    drop_table :account_settings
  end
end
