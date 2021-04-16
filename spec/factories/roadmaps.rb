FactoryBot.define do
  factory :roadmap do
    title { Faker::Lorem.sentence(4) }
    description { Faker::Lorem.sentence(15) }
    status { 1 }
  end
end
