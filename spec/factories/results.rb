FactoryBot.define do
  factory :result do
    description { Faker::Lorem.sentence(200) }
    enabled { true }

    link_ids { [create(:link).id] }

    association :challenge, factory: :challenge
    association :teacher, factory: :teacher

    trait :invalid do
      description { nil }
    end
  end
end
