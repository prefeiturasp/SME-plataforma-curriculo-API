FactoryBot.define do
  factory :curricular_component do
    name 'CurricularComponent 1'

    trait :invalid_name do
      name nil
    end
  end
end
