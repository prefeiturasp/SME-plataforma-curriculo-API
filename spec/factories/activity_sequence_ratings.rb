FactoryBot.define do
  factory :activity_sequence_rating do
    association :activity_sequence_performed, factory: :activity_sequence_performed
    association :rating, factory: :rating

    score { Faker::Number.between(0, 5) }
  end
end
