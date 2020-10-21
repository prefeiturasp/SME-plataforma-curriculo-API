FactoryBot.define do
  factory :project do
    old_id { rand(1..100) }
    name { Faker::Name.name }
    title { Faker::Name.name }
    school { Faker::Name.name }
    dre { Faker::Name.name }
    description { Faker::Name.name }
    summary { Faker::Name.name }
    owners { Faker::Name.name }

    trait :invalid_name do
      name { nil }
    end
  end
end
