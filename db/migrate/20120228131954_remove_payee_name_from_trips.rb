class RemovePayeeNameFromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :payee_name
  end

  def down
		add_column :trips, :payee_name, :string
  end
end
