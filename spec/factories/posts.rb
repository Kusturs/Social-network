FactoryBot.define do
  factory :post do
    association :author, factory: :user
    sequence(:content) { |n| "This is post number #{n}. Your content up to 140 characters can go here." }
  end
end
