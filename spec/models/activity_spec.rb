require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:subject) { build :activity }

  describe 'Associations' do
    it 'belongs to main activity_sequence' do
      should belong_to(:activity_sequence)
    end

    it 'has and belongs to many activity types' do
      should have_and_belong_to_many(:activity_types)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a sequence' do
        subject.sequence = nil

        expect(subject).to_not be_valid
      end

      it 'if the sequence already exists' do
        subject.save
        new_object = build :activity, sequence: subject.sequence

        expect(new_object).to_not be_valid
      end

      it 'without a title' do
        subject.title = nil

        expect(subject).to_not be_valid
      end

      it 'if the title already exists' do
        subject.save
        new_object = build :activity, title: subject.title

        expect(new_object).to_not be_valid
      end

      it 'without a estimated_time' do
        subject.estimated_time = nil

        expect(subject).to_not be_valid
      end

      it 'without a content' do
        subject.content = nil

        expect(subject).to_not be_valid
      end

      it 'without a activity sequence' do
        subject.activity_sequence = nil

        expect(subject).to_not be_valid
      end
    end
  end
end
