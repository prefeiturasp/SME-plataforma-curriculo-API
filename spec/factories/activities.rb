FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence(4) }
    estimated_time { Faker::Number.between(1, 500) }
    content '{"ops":[{"insert":"Text\\n"}]}'
    status :published

    association :activity_sequence, factory: :activity_sequence

    curricular_component_ids { [create(:curricular_component).id] }
    learning_objective_ids { [create(:learning_objective).id] }

    sequence :sequence do |n|
      n
    end

    after(:build) do |activity|
      activity.image.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
        filename: 'ruby.png',
        content_type: 'image/png'
      )
    end

    trait :invalid do
      title nil
      estimated_time nil
      activity_sequence_id nil
    end
  end
end
