class Drone < ApplicationRecord

  validates :latitude, :longitude, :status, :batteryPercent, presence: true
  validates :batteryPercent, :inclusion => 0..100
end