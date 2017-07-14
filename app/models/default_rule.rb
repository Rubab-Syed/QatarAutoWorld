class DefaultRule < ApplicationRecord
  has_many :default_rule_rooms
  has_many :rooms, :through => :default_rule_rooms
end
