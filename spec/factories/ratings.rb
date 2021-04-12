FactoryBot.define do
  factory :rating do
    description { Faker::Lorem.sentence(word_count: 20) }
    enable { true} 
    sequence :sequence do |n|
      n
    end
  end
end
