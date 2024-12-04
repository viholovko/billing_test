FactoryBot.define do
  factory :customer do
    name { "John Doe" }
    email { FFaker::Internet.unique.email }  # Generates a unique random email
    phone { "123-456-7890" }
    # details { { loyalty_points: 100 } }  # Example of using jsonb field

    trait :with_invalid_email do
      email { "invalid_email" }
    end

    trait :without_phone do
      phone { nil }
    end
  end
end