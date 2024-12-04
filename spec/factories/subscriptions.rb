FactoryBot.define do
  factory :subscription do
    association :customer
    amount { 100.0 }
    outstanding_balance { 0.0 }

    trait :with_high_balance do
      outstanding_balance { 500.0 }
    end

    trait :with_no_amount do
      amount { nil }
    end
  end
end 