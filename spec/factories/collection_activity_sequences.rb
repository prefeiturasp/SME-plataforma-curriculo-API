FactoryBot.define do
  factory :collection_activity_sequence do
    association :collection, factory: :collection
    association :activity_sequence, factory: :activity_sequence

    sequence :sequence do |n|
      n
    end
  end
end
