FactoryBot.define do
  factory :collection do
    name { Faker::Lorem.characters(number: 25) }

    association :teacher, factory: :teacher

    trait :invalid do
      name { nil }
    end
  end
end
