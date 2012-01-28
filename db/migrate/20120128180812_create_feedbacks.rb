class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :model
      t.string :view
      t.text :defect
      t.text :suggestion
      t.string :status

      t.timestamps
    end
  end
end
