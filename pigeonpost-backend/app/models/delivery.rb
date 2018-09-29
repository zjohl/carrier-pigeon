class Delivery < ApplicationRecord

  validates :drone_id, :status, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, :sender_id, :receiver_id, presence: true
end