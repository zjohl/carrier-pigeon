class User < ApplicationRecord

  validates :drone_id, :status, :origin, :destination, :sender_id, :receiver_id, presence: true
end