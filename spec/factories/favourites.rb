FactoryBot.define do
  factory :favourite do
    association :favouritable, factory: :challenge
    association :teacher, factory: :teacher
  end
end
