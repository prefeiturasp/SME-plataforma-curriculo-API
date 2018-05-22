require 'rails_helper'

RSpec.describe LearningObjective, type: :model do
  let(:sustainable_development_goal) { build :sustainable_development_goal }
  let(:subject) { build :learning_objective, sustainable_development_goals: [sustainable_development_goal] }

  describe 'Associations' do
    it 'has and belongs to many sustainable development goals' do
      should have_and_belong_to_many(:sustainable_development_goals)
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

  describe 'code' do
    it 'was generated' do
      subject.save

      expect(subject.code).not_to be_nil
    end

    it 'not generated if learning objective is not valid' do
      learning_objective = build :learning_objective,
                                 year: 1,
                                 curricular_component: nil

      expect(learning_objective.generate_code).to be_nil
    end

    it 'generate sequential code number' do
      curricular_component = create :curricular_component, name: 'Ciências Naturais'
      learning_objective = create :learning_objective,
                                  year: 1,
                                  curricular_component: curricular_component,
                                  sustainable_development_goals: [sustainable_development_goal]

      expect(learning_objective.next_sequential_code_number('EF01C')).to eq(2)
    end

    context 'was generated correctly' do
      it 'first number' do
        curricular_component = build :curricular_component, name: 'Ciências Naturais'
        learning_objective = build :learning_objective,
                                   year: 1,
                                   curricular_component: curricular_component,
                                   sustainable_development_goals: [sustainable_development_goal]

        expect(learning_objective.generate_code).to eq('EF01C01')
      end

      it 'if destroy and recreate' do
        curricular_component = create :curricular_component, name: 'Ciências Naturais'
        learning_objective = build :learning_objective,
                                   year: 1,
                                   curricular_component: curricular_component,
                                   sustainable_development_goals: [sustainable_development_goal]

        learning_objective.save
        expect(learning_objective.code).to eq('EF01C01')

        learning_objective.destroy
        learning_objective.save
        expect(learning_objective.code).to eq('EF01C01')
      end

      it 'curricular_component equals Educacao Fisica' do
        curricular_component = build :curricular_component, name: 'Educação Física'
        learning_objective = build :learning_objective,
                                   year: 3,
                                   curricular_component: curricular_component,
                                   sustainable_development_goals: [sustainable_development_goal]

        expect(learning_objective.generate_code).to eq('EF03EF01')
      end
    end
  end
end
