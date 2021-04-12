FactoryBot.define do
  factory :teacher do
    nickname { 'nome válido' }
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
      nickname { 'test nome inválido' }
    end
  end
end
