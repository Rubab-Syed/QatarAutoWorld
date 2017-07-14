class Room < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :house_rules, dependent: :destroy
  has_many :default_rule_rooms
  has_many :default_rules, :through => :default_rule_rooms

  geocoded_by :address
  # after_validation :geocode, if: :address_changed?

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  validates :home_type, presence: true
#  validates :room_type, presence: true
#  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  
  has_many :place_rooms
  has_many :places, :through => :place_rooms

#  validates :listing_name, presence: true, length: {maximum: 60}
#  validates :summary, presence: true, length: {maximum: 500}
  # validates :address, presence: true
  # validates :price, numericality: { only_integer: true, greater_than: 5 }

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :house_rules, allow_destroy: true
  accepts_nested_attributes_for :default_rule_rooms, allow_destroy: true
  accepts_nested_attributes_for :default_rules, allow_destroy: true

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
