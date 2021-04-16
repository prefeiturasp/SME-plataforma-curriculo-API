FactoryBot.define do
  factory :segment do
    name { Faker::Lorem.sentence 4 }
    color { "#7e39a4" }

    sequence :sequence do |n|
      n
    end
  end
end
