FactoryBot.define do
  factory :comment do
    association :post
    association :author, factory: :user

    sequence(:content) { |n| "Test comment #{n}" }

    factory :root_comment do
      parent { nil }
    end

    factory :reply do
      parent { association :comment }
    end
  end
end
