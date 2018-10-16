class Delivery < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  enum status: [:pending, :in_progress, :cancelled, :complete]

  validates :drone_id, :status, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, :sender_id, :receiver_id, presence: true
end