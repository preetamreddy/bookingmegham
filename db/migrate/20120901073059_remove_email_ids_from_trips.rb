class RemoveEmailIdsFromTrips < ActiveRecord::Migration
  def up
    Trip.where("email_ids != ''").each do |trip|
      trip.update_column(:remarks, 
        trip.remarks + 'Copy all email correspondence to the following email_id(s): ' + trip.email_ids)
    end

    remove_column :trips, :email_ids
  end

  def down
    add_column :trips, :email_ids, :string
  end
end
