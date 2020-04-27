FactoryBot.define do
  factory :link do
    link { Faker::Internet.url }
  end
end
