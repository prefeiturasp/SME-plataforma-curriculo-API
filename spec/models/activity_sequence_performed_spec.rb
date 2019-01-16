require 'rails_helper'

RSpec.describe ActivitySequencePerformed, type: :model do
  let(:subject) { build :activity_sequence_performed }

  describe 'Associations' do
    it 'belongs to main activity_sequence' do
      should belong_to(:activity_sequence)
    end

    it 'belongs to teacher' do
      should belong_to(:teacher)
    end
  end

  describe 'Validations' do
    describe 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'if teacher must exists' do
        should validate_presence_of(:teacher).with_message(:required)
      end

      it 'if activity sequence must exists' do
        should validate_presence_of(:activity_sequence).with_message(:required)
      end
    end

    describe 'is not valid' do
      it 'if activity sequence duplicated per teacher' do
        teacher = create :teacher
        activity_sequence = create :activity_sequence
        activity_seq_performed = create :activity_sequence_performed, teacher: teacher, activity_sequence: activity_sequence
        another_activity_seq_performed = build :activity_sequence_performed, teacher: teacher, activity_sequence: activity_sequence

        expect(another_activity_seq_performed).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'by_teacher' do
      let(:teacher) { create :teacher }
      let(:activity_sequence_performed) { create :activity_sequence_performed, teacher: teacher }
      let(:activity_sequence_performed_another_teacher) { create :activity_sequence_performed }

      it 'show only activity sequence performeds by teacher' do
        all_by_teacher = ActivitySequencePerformed.by_teacher(teacher)
        expect(all_by_teacher).to eq([activity_sequence_performed])
        expect(all_by_teacher).to_not eq([activity_sequence_performed_another_teacher])
      end
    end

    context 'evaluateds' do
      let(:activity_sequence_performed_1) { create :activity_sequence_performed, evaluated: true }
      let(:activity_sequence_performed_2) { create :activity_sequence_performed, evaluated: false }
      let(:activity_sequence_performed_3) { create :activity_sequence_performed, evaluated: true }

      it 'List all if evaluated is true' do
        expected = [activity_sequence_performed_1, activity_sequence_performed_3]
        expect(ActivitySequencePerformed.evaluateds).to eq(expected)
      end

      it 'Not list if evaluated is false' do
        expect(ActivitySequencePerformed.evaluateds).to_not include(activity_sequence_performed_2)
      end
    end

    context 'ordered_by_created_at' do
      let(:activity_sequence_performed_first)  { create :activity_sequence_performed }
      let(:activity_sequence_performed_second) { create :activity_sequence_performed }

      it 'list all order by created_at ASC' do
        expected = [activity_sequence_performed_first, activity_sequence_performed_second]
        expect(ActivitySequencePerformed.ordered_by_created_at).to eq(expected)
      end
    end
  end

  context 'Filters' do
    context 'with evaluated' do
      let(:all_response) { ActivitySequencePerformed.all }
      let(:params)   { { evaluated: 'true' } }
      let(:response) { ActivitySequencePerformed.all_or_with_evaluated(params[:evaluated]) }

      it 'return all with none params' do
        response = ActivitySequencePerformed.all_or_with_evaluated

        expect(all_response).to eq(response)
      end

      it 'include' do
        a = create :activity_sequence_performed,
                  evaluated: true
        expect(response).to include(a)
      end

      it 'not include' do
        a = create :activity_sequence_performed,
                  evaluated: false
        expect(response).to_not include(a)
      end
    end
  end
end
