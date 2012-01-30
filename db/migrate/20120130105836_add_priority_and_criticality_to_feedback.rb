class AddPriorityAndCriticalityToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :priority, :string
    add_column :feedbacks, :criticality, :string
  end
end
