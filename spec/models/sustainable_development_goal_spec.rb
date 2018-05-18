require 'rails_helper'

RSpec.describe SustainableDevelopmentGoal, type: :model do
  let(:subject) { build :sustainable_development_goal }

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
end
