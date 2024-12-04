FactoryBot.define do
  factory :payment do
    association :subscription
    amount { 100.0 }
    status { "completed" }

    trait :pending do
      status { "pending" }
    end

    trait :failed do
      status { "failed" }
    end

    trait :with_no_amount do
      amount { nil }
    end
  end
end 