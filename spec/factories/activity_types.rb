FactoryBot.define do
  factory :activity_type do
    name { Faker::Lorem.sentence(4) }

    trait :invalid_name do
      name { nil }
    end
  end
end
