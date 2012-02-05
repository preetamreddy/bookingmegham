class AddMedicalConstraintsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :medical_constraints, :string
  end
end
