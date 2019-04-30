FactoryBot.define do
  factory :result do
    description { Faker::Lorem.sentence(200) }
    class_name { Faker::Lorem.sentence }
    enabled { true }

    link_ids { [create(:link).id] }

    association :challenge, factory: :challenge
    association :teacher, factory: :teacher

    trait :invalid do
      description { nil }
      class_name { nil }
    end
  end
end
