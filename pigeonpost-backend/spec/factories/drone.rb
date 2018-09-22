FactoryBot.define do
  factory :drone do
    sequence(:status) { |n| "some-status" }
    battery_percent { 70 }
    latitude { 0 }
    longitude { 20 }
  end
end