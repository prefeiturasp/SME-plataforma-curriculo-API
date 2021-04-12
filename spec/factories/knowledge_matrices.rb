FactoryBot.define do
  factory :knowledge_matrix do
    title { Faker::Lorem.sentence(word_count: 4) }
    know_description { Faker::Lorem.sentence(word_count: 10) }
    for_description { Faker::Lorem.sentence(word_count: 10) }

    sequence :sequence do |n|
      n
    end
  end
end
