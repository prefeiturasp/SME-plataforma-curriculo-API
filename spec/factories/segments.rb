FactoryBot.define do
  factory :segment do
    name { Faker::Lorem.sentence 4 }
  end
end
