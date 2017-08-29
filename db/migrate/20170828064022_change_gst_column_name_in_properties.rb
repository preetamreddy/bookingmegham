class ChangeGstColumnNameInProperties < ActiveRecord::Migration
  def up
		rename_column :properties, :cgst_rate, :cgst_rate_for_food
		rename_column :properties, :sgst_rate, :sgst_rate_for_food
  end

  def down
		rename_column :properties, :cgst_rate_for_food, :cgst_rate
		rename_column :properties, :sgst_rate_for_food, :sgst_rate
  end
end
