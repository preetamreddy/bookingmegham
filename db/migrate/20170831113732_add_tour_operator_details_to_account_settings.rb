class AddTourOperatorDetailsToAccountSettings < ActiveRecord::Migration
	def up
		add_column :account_settings, :tour_operator_gstin, :string, :default => ""
		add_column :account_settings, :tour_operator_postal_address, :text, :default => ""
		add_column :account_settings, :tour_operator_counter_for_tax_invoice, :integer, :default => 1

		AccountSetting.all.each do |account_setting|
			account_setting.update_column(:tour_operator_gstin, account_setting.gstin)
			account_setting.update_column(:tour_operator_postal_address, account_setting.postal_address)
		end
	end

	def down
		remove_column :account_settings, :tour_operator_gstin
		remove_column :account_settings, :tour_operator_postal_address
		remove_column :account_settings, :tour_operator_counter_for_tax_invoice
	end
end
