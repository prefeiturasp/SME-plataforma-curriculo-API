FactoryBot.define do
  factory :acl do
    reason { Faker::Lorem.sentence(60) }
    enabled { true }

    association :teacher, factory: :teacher

    trait :invalid do
      reason { nil }
    end
  end
end
