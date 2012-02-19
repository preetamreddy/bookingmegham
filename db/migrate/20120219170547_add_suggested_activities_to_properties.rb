class AddSuggestedActivitiesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :suggested_activities, :text
  end
end
