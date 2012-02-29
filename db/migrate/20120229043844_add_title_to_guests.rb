class AddTitleToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :title, :string
  end
end
