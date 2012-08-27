class RemoveDescriptionFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :description
  end

  def down
    add_column :properties, :description, :text
  end
end
