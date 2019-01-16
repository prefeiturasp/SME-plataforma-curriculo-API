require 'rails_helper'

RSpec.describe ActivitySequenceRating, type: :model do
  let(:subject) { create :activity_sequence_rating }

  describe 'Associations' do
    it 'belong to activity sequence performed' do
      should belong_to(:activity_sequence_performed)
    end

    it 'belong to rating' do
      should belong_to(:rating)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'if activity_sequence_performed must exists' do
        should validate_presence_of(:activity_sequence_performed).with_message(:required)
      end

      it 'if rating must exists' do
        should validate_presence_of(:rating).with_message(:required)
      end

      it 'with score equals 0' do
        subject.score = 0

        expect(subject).to be_valid
      end

      it 'with score equals 5' do
        subject.score = 5

        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a score' do
        subject.score = nil

        expect(subject).to_not be_valid
      end

      it 'with score less than 0' do
        subject.score = -1

        expect(subject).to_not be_valid
      end

      it 'if score not is integer' do
        subject.score = 'word'

        expect(subject).to_not be_valid
      end

      it 'with score grether than 5' do
        subject.score = 6

        expect(subject).to_not be_valid
      end

      it 'if activity sequence performed not unique per rating' do
        rating = create :rating
        act_seq_performed = create :activity_sequence_performed
        act_seq_rating = create :activity_sequence_rating, activity_sequence_performed: act_seq_performed, rating: rating
        same_act_seq_rating = build :activity_sequence_rating, activity_sequence_performed: act_seq_performed, rating: rating
        act_seq_another_rating = build :activity_sequence_rating, activity_sequence_performed: act_seq_performed

        expect(same_act_seq_rating).to_not be_valid
        expect(act_seq_another_rating).to be_valid
      end
    end
  end
end
