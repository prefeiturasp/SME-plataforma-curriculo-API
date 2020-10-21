FactoryBot.define do
  factory :advisor do
    old_id { rand(1..100) }
    name { Faker::Name.name }

    trait :invalid_name do
      name { nil }
    end
  end
end
