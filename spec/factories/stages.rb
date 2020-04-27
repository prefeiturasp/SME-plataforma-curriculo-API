FactoryBot.define do
  factory :stage do
    name { Faker::Lorem.sentence 4 }
    association :segment, factory: :segment
  end
end
