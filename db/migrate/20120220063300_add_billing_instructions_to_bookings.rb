class AddBillingInstructionsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :collect_for_all_extras, :integer, :default => 1
    add_column :bookings, :collect_for_children, :integer, :default => 1
    add_column :bookings, :collect_for_driver_and_help, :integer, :default => 1
    add_column :bookings, :bill_agent_on_chosen_plan, :integer, :default => 1
  end
end
