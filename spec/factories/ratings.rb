FactoryBot.define do
  factory :rating do
    description { Faker::Lorem.sentence(20) }
    enable true
    sequence :sequence do |n|
      n
    end
  end
end
