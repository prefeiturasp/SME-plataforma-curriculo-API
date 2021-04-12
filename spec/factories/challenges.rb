FactoryBot.define do
  factory :challenge do
    title { Faker::Lorem.sentence word_count: 4 }
    finish_at { Faker::Date.forward days: 20 }
    status { :published }
    category { :project }
    keywords { 'keyword 1, keyword 2' }

    learning_objective_ids { [create(:learning_objective).id] }
    curricular_component_ids { [create(:curricular_component).id] }

    after(:build) do |challenge|
      challenge.image.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
        filename: 'ruby.png',
        content_type: 'image/png'
      )
    end

    trait :invalid do
      title { nil }
      finish_at { nil }
    end
  end
end
