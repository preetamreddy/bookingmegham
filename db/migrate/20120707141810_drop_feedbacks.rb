class DropFeedbacks < ActiveRecord::Migration
  def up
		drop_table :feedbacks
  end

  def down
    create_table :feedbacks do |t|
      t.string :model
      t.string :view
      t.text :description
      t.string :status
    	t.string :priority
    	t.string :criticality
			t.integer :account_id

      t.timestamps
    end

		add_index "feedbacks", ["account_id"], :name => "index_feedbacks_on_account_id"
  end
end
