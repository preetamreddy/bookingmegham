class AddTaxSettingToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :tax_setting, :string
  end
end
