FactoryBot.define do
  factory :goal do
    description { Faker::Lorem.sentence(10) }
    association :sustainable_development_goal, factory: :sustainable_development_goal

    trait :invalid_sustainable_development_goal do
      sustainable_development_goal nil
    end
  end
end
