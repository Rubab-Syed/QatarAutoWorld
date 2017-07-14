class Place < ActiveRecord::Base
  enum _type: [ :city, :town ]
  enum locality: [ :plain, :north ]
  has_many :place_rooms
  has_many :rooms, :through => :place_rooms
end
