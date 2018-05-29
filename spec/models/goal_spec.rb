require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:subject) { build :goal }

  describe 'Associations' do
    it { should belong_to(:sustainable_development_goal) }
  end

  describe 'Validations' do
    describe 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'if sustainable development goal must exists' do
        should validate_presence_of(:sustainable_development_goal).with_message(:required)
      end
    end

    describe 'is not valid' do
      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        subject.reload
        new_subject = build :goal, description: subject.description

        expect(new_subject).to_not be_valid
      end

      it 'if sustainable development goal is null' do
        invalid_subject = build :goal, :invalid_sustainable_development_goal

        expect(invalid_subject).to_not be_valid
      end
    end
  end
end
