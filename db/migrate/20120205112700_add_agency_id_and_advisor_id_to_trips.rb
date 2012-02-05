class AddAgencyIdAndAdvisorIdToTrips < ActiveRecord::Migration
  def change
		add_column :trips, :agency_id, :integer
		add_column :trips, :advisor_id, :integer
  end
end
