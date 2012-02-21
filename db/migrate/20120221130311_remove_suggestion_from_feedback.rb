class RemoveSuggestionFromFeedback < ActiveRecord::Migration
  def up
		remove_column :feedbacks, :suggestion
  end

  def down
		add_column :feedbacks, :suggestion, :text
  end
end
