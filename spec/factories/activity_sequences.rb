FactoryBot.define do
  factory :activity_sequence do
    title { Faker::Lorem.sentence(4) }
    presentation_text { Faker::Lorem.sentence(10) }
    books { Faker::Lorem.sentence(10) }
    estimated_time { Faker::Number.between(1, 500) }
    year :first
    status :draft

    after(:build) do |activity_sequence|
      activity_sequence.image.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
        filename: 'ruby.png',
        content_type: 'image/png'
      )
    end

    association :main_curricular_component, factory: :curricular_component

    sustainable_development_goal_ids { [create(:sustainable_development_goal).id] }
    curricular_component_ids { [create(:curricular_component).id] }
    knowledge_matrix_ids { [create(:knowledge_matrix).id] }
    learning_objective_ids { [create(:learning_objective).id] }

    trait :invalid do
      title nil
      presentation_text nil
      year nil
    end
  end
end
