FactoryBot.define do
  factory :delivery do
  	sequence(:drone_id) { |n| n }
    sequence(:status) { |n| n % 4 }
    origin_latitude { 1 }
    origin_longitude { 2 }
    destination_latitude { 3 }
    destination_longitude { 4 }
    sender_id { 5 }
    receiver_id { 6 }
  end
end