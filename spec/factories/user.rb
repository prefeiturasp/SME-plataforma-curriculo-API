FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username(5..8) }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
    _skip_creating_teacher { true }

    trait :with_teacher do
      _skip_creating_teacher { false }
    end
  end
end
