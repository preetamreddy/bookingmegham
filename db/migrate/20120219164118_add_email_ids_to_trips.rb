class AddEmailIdsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :email_ids, :string
  end
end
