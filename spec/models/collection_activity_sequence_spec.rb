require 'rails_helper'

RSpec.describe CollectionActivitySequence, type: :model do
  describe 'Associations' do
    it 'belongs to collection' do
      should belong_to(:collection)
    end

    it 'belongs to activity_sequence' do
      should belong_to(:activity_sequence)
    end
  end

  describe 'Validations' do
    let(:collection) { create :collection }
    let(:activity_sequence) { create :activity_sequence }
    let(:subject) { create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence }

    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'with same activity sequence in collection scope' do
        collection_activity_sequence = build :collection_activity_sequence, collection: subject.collection, activity_sequence: subject.activity_sequence

        expect(collection_activity_sequence).to_not be_valid
      end

      it 'with sequence not is a integer' do
        subject.sequence = 'string'
        expect(subject).to_not be_valid

        subject.sequence = true
        expect(subject).to_not be_valid
      end

      it 'with sequence less than zero' do
        subject.sequence = -1

        expect(subject).to_not be_valid
      end

      it 'with sequence eqauls zero' do
        subject.sequence = 0

        expect(subject).to_not be_valid
      end
    end
  end
end
