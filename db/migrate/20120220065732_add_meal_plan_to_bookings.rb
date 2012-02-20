class AddMealPlanToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :meal_plan, :string
  end
end
