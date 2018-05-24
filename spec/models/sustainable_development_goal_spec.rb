require 'rails_helper'

RSpec.describe SustainableDevelopmentGoal, type: :model do
  let(:subject) { build :sustainable_development_goal }

  describe 'Associations' do
    it 'has and belongs to many learning objectives' do
      should have_and_belong_to_many(:learning_objectives)
    end

    it 'has and belongs to many activity sequences' do
      should have_and_belong_to_many(:activity_sequences)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'contains icon' do
        expect(subject.icon).to be_an_instance_of(ActiveStorage::Attached::One)
      end
    end

    context 'is not valid' do
      it 'without a sequence' do
        subject.sequence = nil

        expect(subject).to_not be_valid
      end

      it 'without a name' do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'without a goals' do
        subject.goals = nil

        expect(subject).to_not be_valid
      end

      it 'without an icon' do
        subject.icon.purge

        expect(subject).to_not be_valid
      end

      it 'if the sequence already exists' do
        subject.save
        new_subject = build :sustainable_development_goal, sequence: subject.sequence

        expect(new_subject).to_not be_valid
      end

      it 'if the sequence already exists' do
        subject.save
        new_subject = build :sustainable_development_goal, name: subject.name

        expect(new_subject).to_not be_valid
      end

      it 'if it is not the image format' do
        subject.icon.purge
        subject.icon.attach(
          io: File.open(Rails.root.join('spec', 'factories', 'images', 'format_test.txt')),
          filename: 'format_test.txt',
          content_type: 'text/plain'
        )

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Methods' do
    it 'goals raw return safe buffer' do
      subject.goals = 'Goals 1; Goals 2; Goals 3'

      expect(subject.goals_raw).to be_an_instance_of(ActiveSupport::SafeBuffer)
      expect(subject.goals_raw).to include('Goals 1')
      expect(subject.goals_raw).to include('Goals 3')
    end

    it 'goals raw separate with <br />' do
      subject.goals = 'Goals 1; Goals 2; Goals 3'

      expect(subject.goals_raw).to include('Goals 1<br />')
      expect(subject.goals_raw).to include('Goals 2<br />')
    end
  end
end
