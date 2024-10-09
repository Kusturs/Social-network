FactoryBot.define do
  factory :profile do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    association :user
  end
end
