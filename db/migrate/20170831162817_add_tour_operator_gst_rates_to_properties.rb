class AddTourOperatorGstRatesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :tour_operator_cgst_rate, :float, :default => 0.0
    add_column :properties, :tour_operator_sgst_rate, :float, :default => 0.0
    add_column :properties, :tour_operator_igst_rate, :float, :default => 0.0
  end
end
