class Drone < ApplicationRecord

  validates :latitude, :longitude, :status, :battery_percent, presence: true
  validates :battery_percent, :inclusion => 0..100
end