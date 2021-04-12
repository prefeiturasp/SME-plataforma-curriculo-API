FactoryBot.define do
  factory :result do
    description { Faker::Lorem.sentence(word_count: 200) }
    class_name { Faker::Lorem.sentence }
    enabled { true }

    association :challenge, factory: :challenge
    association :teacher, factory: :teacher

    after(:build) do |result|
      result.links.build link: Faker::Internet.url

      rand(1..3).times do
        document = ['1.jpg', '2.jpg', '3.jpg', '4.jpg'].sample

        result.archives.attach(
          io:           File.open(Rails.root.join('spec', 'fixtures', 'activities', document)),
          filename:     document,
          content_type: 'image/jpg'
        )
      end

      rand(1..2).times do
        document = ['sample.doc', 'sample.pdf'].sample

        result.archives.attach(
          filename:     document,
          content_type: (document == 'sample.doc' ? 'application/msword' : 'application/pdf'),
          io:           File.open(Rails.root.join('spec', 'fixtures', 'documents', document))
        )
      end
    end

    trait :invalid do
      description { nil }
      class_name { nil }
    end
  end
end
