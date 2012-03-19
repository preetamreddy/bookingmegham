class AddIsTravelAgencyToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :is_travel_agency, :integer, :default => 1
  end
end
