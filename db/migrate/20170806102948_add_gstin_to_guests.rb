class AddGstinToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :gstin, :string
  end
end
