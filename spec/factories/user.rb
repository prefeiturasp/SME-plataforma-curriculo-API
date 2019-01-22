FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end
end
