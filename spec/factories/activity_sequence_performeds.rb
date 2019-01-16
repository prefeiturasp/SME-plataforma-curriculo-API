FactoryBot.define do
  factory :activity_sequence_performed do
    association :activity_sequence, factory: :activity_sequence
    association :teacher, factory: :teacher
    evaluated false
  end
end
