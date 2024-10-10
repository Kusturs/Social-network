FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name) { |n| "last_name#{n}" }
    sequence(:second_name) { |n| "second_name#{n}" }
    followers_count { 0 }
    followed_count { 0 }

    trait :with_profile do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end

    trait :with_active_subscription do
      after(:create) do |user|
        create(:subscription, follower: user, followed: create(:user))
      end
    end
    
    trait :with_passive_subscription do
        after(:create) do |user|
          create(:subscription, follower: create(:user), followed: user)
        end
      end
    end
end
