class DropTableVersions < ActiveRecord::Migration
  def up
		drop_table :versions
  end

  def down
		create_table :versions do |t|
			t.belongs_to :versioned, :polymorphic => true
			t.belongs_to :user, :polymorphic => true
			t.string  :user_name
			t.text    :modifications
			t.integer :number
			t.integer :reverted_from
			t.string  :tag

			t.timestamps
		end

		change_table :versions do |t|
			t.index [:versioned_id, :versioned_type]
			t.index [:user_id, :user_type]
			t.index :user_name
			t.index :number
			t.index :tag
			t.index :created_at
		end
  end
end
