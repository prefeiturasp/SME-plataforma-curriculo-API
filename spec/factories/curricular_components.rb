FactoryBot.define do
  factory :curricular_component do
    name { Faker::Name.name }
    color { Faker::Color.hex_color }

    trait :invalid_name do
      name nil
    end
  end
end
