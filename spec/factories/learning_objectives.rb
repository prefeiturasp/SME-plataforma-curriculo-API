FactoryBot.define do
  factory :learning_objective do
    description { Faker::Lorem.sentence(word_count: 20) }

    sequence(:code) { |n| "#{Faker::Code.asin}#{n}" }

    association :curricular_component, factory: :curricular_component
    association :segment, factory: :segment
    association :stage, factory: :stage
    association :year, factory: :year
    sustainable_development_goals { [create(:sustainable_development_goal)] }
    axes { [create(:axis)] }
  end
end
