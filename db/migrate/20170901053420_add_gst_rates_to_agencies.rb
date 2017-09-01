class AddGstRatesToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :cgst_rate_for_tour_operator, :float, :default => 0.0
    add_column :agencies, :sgst_rate_for_tour_operator, :float, :default => 0.0
    add_column :agencies, :igst_rate_for_tour_operator, :float, :default => 0.0
  end
end
