class AddGstRatesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :cgst_rate, :float, :default => 0.0
    add_column :properties, :sgst_rate, :float, :default => 0.0
  end
end
