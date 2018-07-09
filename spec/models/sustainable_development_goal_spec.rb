require 'rails_helper'

RSpec.describe SustainableDevelopmentGoal, type: :model do
  include_examples 'sequence_concern_spec'
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

      it 'contains sub_icon' do
        expect(subject.sub_icon).to be_an_instance_of(ActiveStorage::Attached::One)
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

      it 'without an icon' do
        subject.icon.purge

        expect(subject).to_not be_valid
      end


      it 'without a sub icon' do
        subject.sub_icon.purge

        expect(subject).to_not be_valid
      end

      it 'without a color' do
        subject.color = nil

        expect(subject).to_not be_valid
      end

      it 'if the color already exists' do
        subject.save
        new_subject = build :sustainable_development_goal, color: subject.color

        expect(new_subject).to_not be_valid
      end


      it 'if the sequence already exists' do
        subject.save
        new_subject = build :sustainable_development_goal, name: subject.name

        expect(new_subject).to_not be_valid
      end

      it 'if icon it is not the image format' do
        subject.icon.purge
        subject.icon.attach(
          io: File.open(Rails.root.join('spec', 'factories', 'images', 'format_test.txt')),
          filename: 'format_test.txt',
          content_type: 'text/plain'
        )

        expect(subject).to_not be_valid
      end

      it 'if sub icon it is not the image format' do
        subject.sub_icon.purge
        subject.sub_icon.attach(
          io: File.open(Rails.root.join('spec', 'factories', 'images', 'format_test.txt')),
          filename: 'format_test.txt',
          content_type: 'text/plain'
        )

        expect(subject).to_not be_valid
      end
    end
  end
  it_behaves_like 'sequence_concern_spec'
end
