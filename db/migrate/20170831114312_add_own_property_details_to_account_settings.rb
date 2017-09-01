class AddOwnPropertyDetailsToAccountSettings < ActiveRecord::Migration
	def up
		add_column :account_settings, :own_property_gstin, :string, :default => ""
		add_column :account_settings, :own_property_postal_address, :text, :default => ""
		add_column :account_settings, :own_property_counter_for_tax_invoice, :integer, :default => 1

		AccountSetting.all.each do |account_setting|
			account_setting.update_column(:own_property_gstin, account_setting.gstin)
			account_setting.update_column(:own_property_postal_address, account_setting.postal_address)
		end
	end

	def down
		remove_column :account_settings, :own_property_gstin
		remove_column :account_settings, :own_property_postal_address
		remove_column :account_settings, :own_property_counter_for_tax_invoice
	end
end
