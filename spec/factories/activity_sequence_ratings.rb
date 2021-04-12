FactoryBot.define do
  factory :activity_sequence_rating do
    association :activity_sequence_performed, factory: :activity_sequence_performed
    association :rating, factory: :rating

    score { Faker::Number.between(from: 0, to: 5) }
  end
end
