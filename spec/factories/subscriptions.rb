FactoryBot.define do
  factory :subscription do
    association :follower, factory: :user
    association :followed, factory: :user
  end
end
