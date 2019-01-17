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
        act_seq_rating = create :activity_sequence_rating,
                                activity_sequence_performed: act_seq_performed, rating: rating
        same_act_seq_rating = build :activity_sequence_rating,
                                    activity_sequence_performed: act_seq_performed, rating: rating
        act_seq_another_rating = build :activity_sequence_rating, activity_sequence_performed: act_seq_performed

        expect(act_seq_rating).to be_valid
        expect(same_act_seq_rating).to_not be_valid
        expect(act_seq_another_rating).to be_valid
      end
    end
  end

  describe 'Callbacks' do
    context 'on after save' do
      it 'assign evaluated TRUE on activity sequence performed' do
        act_seq_performed = create :activity_sequence_performed, evaluated: false
        create :activity_sequence_rating, activity_sequence_performed: act_seq_performed

        expect(act_seq_performed.evaluated?).to be true
      end
    end

    context 'on after destroy' do
      it 'assign evaluated FALSE on activity sequence performed' do
        act_seq_performed = create :activity_sequence_performed, evaluated: false
        act_seq_rating = create :activity_sequence_rating, activity_sequence_performed: act_seq_performed

        act_seq_rating.destroy

        expect(act_seq_performed.evaluated?).to be false
      end
    end
  end

  describe 'Class Methods' do
    context 'create multiple ratings' do
      let(:rating_1) { create :rating, enable: true }
      let(:rating_2) { create :rating, enable: true }
      let(:activity_sequence_performed) { create :activity_sequence_performed }
      let(:valid_attributes) do
        [
          { "rating_id": rating_1.id, "score": '1', "activity_sequence_performed_id": activity_sequence_performed.id },
          { "rating_id": rating_2.id, "score": '2', "activity_sequence_performed_id": activity_sequence_performed.id }
        ]
      end
      let(:invalid_attributes) do
        [
          { "rating_id": rating_1.id, "score": '1', "activity_sequence_performed_id": activity_sequence_performed.id }
        ]
      end
      let(:attributes_with_errors) do
        [
          { "rating_id": rating_1.id, "score": '1', "activity_sequence_performed_id": activity_sequence_performed.id },
          { "rating_id": rating_2.id, "score": '10', "activity_sequence_performed_id": activity_sequence_performed.id }
        ]
      end

      it 'return nil if params not contains all ratings types' do
        create :rating, enable: true
        expect(ActivitySequenceRating.create_multiples(invalid_attributes)).to be nil
      end

      it 'return last object if already created' do
        expected_return = ActivitySequenceRating.create_multiples(valid_attributes)

        expect(expected_return).to eq(ActivitySequenceRating.last)
      end

      it 'return errors if params contains errors' do
        expected_return = ActivitySequenceRating.create_multiples(attributes_with_errors)

        expect(expected_return.errors.present?).to be true
      end
    end

    context 'contains_all_enabled_ratings?' do
      it 'params contains all enable rating types' do
        rating_1 = create :rating, enable: true
        rating_2 = create :rating, enable: true
        array_params = [
          { "rating_id": rating_1.id, "score": '1', "activity_sequence_performed_id": 1 },
          { "rating_id": rating_2.id, "score": '1', "activity_sequence_performed_id": 2 }
        ]

        expect(ActivitySequenceRating.contains_all_enabled_ratings?(array_params)).to be true
      end

      it 'return false if params without a enabled rating' do
        rating_1 = create :rating, enable: true
        create :rating, enable: true
        array_params = [
          { "rating_id": rating_1.id, "score": '1', "activity_sequence_performed_id": 1 }
        ]

        expect(ActivitySequenceRating.contains_all_enabled_ratings?(array_params)).to_not be true
      end
    end
  end
end
