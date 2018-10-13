class Delivery < ApplicationRecord
  has_one :sender, :class_name => "User"
  has_one :receiver, :class_name => "User"

  validates :drone_id, :status, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, :sender_id, :receiver_id, presence: true
end