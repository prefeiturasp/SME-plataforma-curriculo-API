FactoryBot.define do
  factory :activity_sequence do
    title { Faker::Lorem.sentence(4) }
    presentation_text { Faker::Lorem.sentence(10) }
    books { Faker::Lorem.sentence(10) }
    estimated_time { Faker::Number.between(1, 500) }
    year { :first }
    status { :draft }
    keywords { 'keyword 1, keyword 2' }

    after(:build) do |activity_sequence|
      activity_sequence.image.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
        filename: 'ruby.png',
        content_type: 'image/png'
      )
    end

    association :main_curricular_component, factory: :curricular_component
    association :segment, factory: :segment
    association :stage, factory: :stage
    
    knowledge_matrix_ids { [create(:knowledge_matrix).id] }
    learning_objectives { [create(:learning_objective)] }

    trait :invalid do
      title { nil }
      presentation_text { nil }
      year { nil }
    end

    trait :reindex do
      after(:create) do |activity_sequence, _evaluator|
        activity_sequence.reindex(refresh: true)
      end
    end
  end
end
