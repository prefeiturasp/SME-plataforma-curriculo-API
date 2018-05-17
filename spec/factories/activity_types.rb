FactoryBot.define do
  factory :activity_type do
    name 'ActivityType 1'

    trait :invalid_name do
      name nil
    end
  end
end
