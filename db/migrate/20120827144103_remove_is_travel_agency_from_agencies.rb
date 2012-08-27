class RemoveIsTravelAgencyFromAgencies < ActiveRecord::Migration
  def up
    remove_column :agencies, :is_travel_agency
  end

  def down
    add_column :agencies, :is_travel_agency, :integer
  end
end
