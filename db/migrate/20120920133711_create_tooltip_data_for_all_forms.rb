class CreateTooltipDataForAllForms < ActiveRecord::Migration
  def up
    Tooltip.create(:title => 'Service tax rate', :markup => 'markdown',
                   :content => 'You can enter service tax rate if you own the property and want service tax to be calculated for all bookings. This will not be added to the booking cost however.')
    Tooltip.create(:title => 'Activities', :markup => 'markdown',
                   :content => 'Activities for guests during their stay at the property')
    Tooltip.create(:title => 'Number of rooms', :markup => 'markdown',
                   :content => 'For properties that you do not own, this need not be exact. You could input any number greater than or equal to 0.')
    Tooltip.create(:title => 'Lodging', :markup => 'markdown',
                   :content => 'This is the declared lodging price used for calculating service tax - when it is multiplied with the service tax rate as defined for the property.')
  end

  def down
    Tooltip.delete_all
  end
end
