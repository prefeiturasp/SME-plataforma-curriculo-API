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
  end
end
