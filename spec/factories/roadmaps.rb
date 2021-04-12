FactoryBot.define do
  factory :roadmap do
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.sentence(word_count: 15) }
    status { 1 }
  end
end
