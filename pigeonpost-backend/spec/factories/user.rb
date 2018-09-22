FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:first_name) { |n| "person#{n}first" }
    sequence(:last_name) { |n| "person#{n}last" }
    sequence(:password) { |n| "person#{n}password" }
  end
end