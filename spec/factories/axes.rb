FactoryBot.define do
  factory :axis do
    description { Faker::Lorem.sentence(word_count: 10) }
    association :curricular_component, factory: :curricular_component

    trait :invalid_description do
      description { nil }
    end

    trait :invalid_curricular_component do
      curricular_component { nil }
    end
  end
end
