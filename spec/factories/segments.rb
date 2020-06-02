FactoryBot.define do
  factory :segment do
    name { Faker::Lorem.sentence 4 }
    color { "#7e39a4" }
  end
end
