class AddGstRatesForTourOperatorServicesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :cgst_rate_for_tour_operator_services, :float, :default => 0.0
    add_column :properties, :sgst_rate_for_tour_operator_services, :float, :default => 0.0
  end
end
