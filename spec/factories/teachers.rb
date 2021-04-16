FactoryBot.define do
  factory :teacher do
    nickname { Faker::Internet.user_name(7..15) }
    name { Faker::Name.unique.name }

    after(:build) do |teacher|
      teacher.avatar.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'ruby.png')),
        filename: 'ruby.png',
        content_type: 'image/png'
      )
    end

    association :user, factory: :user

    trait :invalid do
      nickname { Faker::Internet.user_name(16..20) }
    end
  end
end
