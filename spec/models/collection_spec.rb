require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:subject) { create :collection }

  describe 'Associations' do
    it 'belongs to teacher' do
      should belong_to(:teacher)
    end

    it 'has_many to collection_activity_sequences' do
      have_many(:collection_activity_sequences)
    end

    it 'has_many to activity_sequences' do
      have_many(:activity_sequences)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid params' do
        expect(subject).to be_valid
      end

      it 'with name length is equals 30 characters' do
        subject.name = Faker::Lorem.characters(30)

        expect(subject).to be_valid
      end
    end

    context 'is invalid' do
      it 'without a name' do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it 'if name greather than 30 characters' do
        subject.name = Faker::Lorem.characters(31)

        expect(subject).to_not be_valid
      end

      it 'if teacher is nil' do
        subject.teacher_id = nil

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'activity sequences default scope' do
    it 'orders by ascending sequence' do
      activity_sequence_one = create :activity_sequence, title: 'ZZZZZ'
      activity_sequence_two = create :activity_sequence, title: 'AAAA'

      collection = create :collection
      create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence_one, sequence: 2
      create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence_two, sequence: 5

      expect(collection.activity_sequences).to eq([activity_sequence_one, activity_sequence_two])
    end
  end

  describe 'Methods' do
    it 'returns number of published activity sequences' do
      activity_sequence_one = create :activity_sequence, status: :published
      activity_sequence_two = create :activity_sequence, status: :published

      collection = create :collection
      create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence_one
      create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence_two

      expect(collection.number_of_published_activity_sequences).to eq(2)
    end
  end
end
