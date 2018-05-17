FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    trait :superadmin do
      superadmin true
    end
  end
end
