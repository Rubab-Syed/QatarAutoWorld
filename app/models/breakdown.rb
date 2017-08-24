class Breakdown < ActiveRecord::Base
  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star)
  end

  def get_first_available_price
    if self.nightly_enabled && self.price.present?
      return "Rs. " + self.price.to_s
    elsif self.weekly_enabled && self.weekly_price.present?
      return "Rs. " + self.weekly_price.to_s 
    elsif self.monthly_enabled && self.monthly_price.present?
      return "Rs. " + self.monthly_price.to_s
    end
  end
end
