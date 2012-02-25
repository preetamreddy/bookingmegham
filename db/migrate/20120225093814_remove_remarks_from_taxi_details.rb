class RemoveRemarksFromTaxiDetails < ActiveRecord::Migration
  def up
		remove_column :taxi_details, :remarks
  end

  def down
		add_column :taxi_details, :remarks, :text
  end
end
