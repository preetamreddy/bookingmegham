class RenameServiceTaxRateToStrOldInProperties < ActiveRecord::Migration
  def up
    rename_column :properties, :service_tax_rate, :str_old
  end

  def down
    rename_column :properties, :str_old, :service_tax_rate
  end
end
