class AddSuggestedActivitiesToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :suggested_activities, :text
  end
end
