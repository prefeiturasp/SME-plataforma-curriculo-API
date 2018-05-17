FactoryBot.define do
  factory :axis do
    description 'Axis 1'
    association :curricular_component, factory: :curricular_component

    trait :invalid_description do
      description nil
    end

    trait :invalid_curricular_component do
      curricular_component nil
    end
  end
end
