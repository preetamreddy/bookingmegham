class RenameDefectToDescriptionInFeedback < ActiveRecord::Migration
  def up
		rename_column :feedbacks, :defect, :description
  end

  def down
		rename_column :feedbacks, :description, :defect
  end
end
