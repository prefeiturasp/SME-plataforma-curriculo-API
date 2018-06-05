require 'rails_helper'

RSpec.describe LearningObjective, type: :model do
  let(:sustainable_development_goal) { build :sustainable_development_goal }
  let(:subject) { build :learning_objective, sustainable_development_goals: [sustainable_development_goal] }

  describe 'Associations' do
    it 'belongs to curricular component' do
      should belong_to(:curricular_component)
    end

    it 'has and belongs to many sustainable development goals' do
      should have_and_belong_to_many(:sustainable_development_goals)
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
    end

    context 'not is valid' do
      it 'without a year' do
        subject.year = nil

        expect(subject).to_not be_valid
      end

      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'without a code' do
        subject.code = nil

        expect(subject).to_not be_valid
      end

      it 'without a curricular component' do
        subject.curricular_component_id = nil

        expect(subject).to_not be_valid
      end

      it 'without a sustainable development goal' do
        subject.sustainable_development_goal_ids = []

        expect(subject).to_not be_valid
      end
    end
  end
end
