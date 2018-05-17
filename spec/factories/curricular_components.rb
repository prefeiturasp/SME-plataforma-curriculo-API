FactoryBot.define do
  factory :curricular_component do
    name { Faker::Name.name }

    trait :invalid_name do
      name nil
    end
  end
end
