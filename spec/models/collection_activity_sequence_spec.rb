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

      it 'with sequence nil' do
        subject.sequence = nil

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

  describe 'Order activity sequences' do
    let(:activity_sequence) { create :activity_sequence }
    context 'on Insert' do
      context 'in the first element, expect sequence equals 1' do
        it 'if sequence equals 1' do
          collection = create :collection
          subject =  create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence, sequence: 1

          subject.reload
          expect(subject.sequence).to eq(1)
        end

        it 'if the sequence greather than 1' do
          collection = create :collection
          subject =  create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence, sequence: Faker::Number.between(from: 2, to: 100)

          subject.reload
          expect(subject.sequence).to eq(1)
        end

        it 'if the sequence equals nil' do
          collection = create :collection
          subject =  create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence, sequence: nil

          subject.reload
          expect(subject.sequence).to eq(1)
        end
      end

      context 'in the middle list' do
        let!(:collection) { create :collection }
        let!(:collection_one) { create(:collection_activity_sequence, collection: collection, sequence: 1) }
        let!(:collection_two) { create(:collection_activity_sequence, collection: collection, sequence: 2) }
        let!(:collection_three) { create(:collection_activity_sequence, collection: collection, sequence: 3) }

        it 'if sequence already exists, move to the next sequence all elements' do
          new_collection_two = create :collection_activity_sequence, collection: collection, sequence: 2

          expect(collection_three.reload.sequence).to eq(4)
          expect(collection_two.reload.sequence).to eq(3)
          expect(new_collection_two.reload.sequence).to eq(2)
        end
      end

      context 'at the end of the list' do
        let!(:collection) { create :collection }
        let!(:collection_one) { create(:collection_activity_sequence, collection: collection, sequence: 1) }
        let!(:collection_two) { create(:collection_activity_sequence, collection: collection, sequence: 2) }

        it 'insert in the end list' do
          new_col_act_seq = create :collection_activity_sequence, collection: collection, sequence: 3

          expect(collection.collection_activity_sequences.last).to eq(new_col_act_seq)
          expect(new_col_act_seq.reload.sequence).to eq(3)
        end
      end

      context 'if the sequence is nil' do
        let!(:collection) { create :collection }
        let!(:collection_one) { create(:collection_activity_sequence, collection: collection, sequence: 1) }

        it 'move to the last position in the list' do
          last_sequence_before = collection.collection_activity_sequences.last.sequence
          next_sequence = last_sequence_before + 1

          new_col_act_seq = create :collection_activity_sequence, collection: collection, sequence: nil

          expect(collection.collection_activity_sequences.last).to eq(new_col_act_seq)
          expect(new_col_act_seq.reload.sequence).to eq(next_sequence)
        end
      end

      context 'if the sequence is greater than the last element in the list' do
        let!(:collection) { create :collection }
        let!(:collection_one) { create(:collection_activity_sequence, collection: collection, sequence: 1) }
        let!(:collection_two) { create(:collection_activity_sequence, collection: collection, sequence: 2) }

        it 'assign element on last_sequence + 1' do
          last_sequence_before = collection.collection_activity_sequences.last.sequence
          next_sequence = last_sequence_before + 1
          random_sequence = last_sequence_before + Faker::Number.between(from: 5, to: 100)

          new_col_act_seq = create :collection_activity_sequence, collection: collection, sequence: random_sequence

          expect(collection.collection_activity_sequences.last).to eq(new_col_act_seq)
          expect(new_col_act_seq.reload.sequence).to eq(next_sequence)
        end
      end
    end
  end

  describe 'public methods' do
    it 'return all collection_activity_sequences from the same object collection' do
      collection = create :collection
      collection_one = create(:collection_activity_sequence, collection: collection, sequence: 1)
      collection_two = create(:collection_activity_sequence, collection: collection, sequence: 2)

      expect(collection_one.collection_activity_sequences_from_collection).to eq(collection_two.collection_activity_sequences_from_collection)
    end
  end
end
