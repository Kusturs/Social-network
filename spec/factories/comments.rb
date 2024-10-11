FactoryBot.define do
  factory :comment do
    association :post
    association :author, factory: :user

    sequence(:content) { |n| "Test comment #{n}" }

    factory :root_comment do
      parent { nil }
    end

    factory :reply do
      transient do
        parent_comment { nil }
      end

      parent { parent_comment || association(:comment) }
      post { parent&.post }

      after(:build) do |comment, _evaluator|
        comment.post ||= comment.parent.post if comment.parent
      end
    end
  end
end
