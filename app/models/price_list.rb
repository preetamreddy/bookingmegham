class PriceList < ActiveRecord::Base
  belongs_to :room_type

  validates :room_type_id, :account_id, :meal_plan, :start_date, :end_date,
    :price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_extra_adults, :price_for_children, :price_for_infants,
    :presence => true
  validates_numericality_of :room_type_id, :account_id, 
    :price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_extra_adults,
    :allow_nil => true, :only_integer => true, :greater_than => 0,
    message: "should be a number greater than 0"
  validates_numericality_of :price_for_children, :price_for_infants,
    :allow_nil => true, :only_integer => true, :greater_than_or_equal_to => 0,
    message: "should be a number greater than or equal to 0"

  validate :ensure_dates_are_not_in_the_past,
    :ensure_end_date_is_greater_than_start_date,
    :ensure_uniqueness_of_price_list

  private
    def ensure_dates_are_not_in_the_past
      if new_record?
        if start_date < Date.today
          errors.add(:base, "New Price list cannot be created for past dates.")
          return false
        else
          return true
        end 
      else
        if (start_date_changed? and start_date < Date.today) or
           (end_date_changed? and end_date < Date.today)
          errors.add(:base, "Price list start / end date cannot be updated to a past date.")
          return false
        else
          return true
        end 
      end
    end

    def ensure_end_date_is_greater_than_start_date
      if end_date <= start_date
        errors.add(:base, "Price list end date cannot be less than start date.")
        return false
      else
        return true
      end
    end

    def ensure_uniqueness_of_price_list
      if PriceList.where('id != :id and room_type_id = :room_type_id and meal_plan = :meal_plan and
                          ( (start_date <= :start_date and end_date >= :start_date) or
                            (start_date <= :end_date and end_date >= :end_date) )',
                        {:id => id, :room_type_id => room_type_id, :meal_plan => meal_plan,
                          :start_date => start_date, :end_date => end_date}).any?
        errors.add(:base, "There is an overlap with another price list. Please check the dates.")
        return false
      else
        return true
      end
    end
end