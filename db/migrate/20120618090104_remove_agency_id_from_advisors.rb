class RemoveAgencyIdFromAdvisors < ActiveRecord::Migration
  def up
		remove_column :advisors, :agency_id
  end

  def down
		add_column :advisors, :agency_id, :integer
  end
end
