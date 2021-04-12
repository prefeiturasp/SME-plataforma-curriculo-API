FactoryBot.define do
  factory :year do
    name { Faker::Lorem.sentence word_count: 4 }
    association :stage, factory: :stage
    association :segment, factory: :segment

    sequence :sequence do |n|
      n
    end
  end
end
