FactoryBot.define do
  factory :learning_objective do
    year :first
    description { Faker::Lorem.sentence(20) }

    association :curricular_component, factory: :curricular_component
    sustainable_development_goals { [create(:sustainable_development_goal)] }
  end
end
