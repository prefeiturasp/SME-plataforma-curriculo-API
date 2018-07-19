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

      it 'without a sustainable development goal' do
        subject.sustainable_development_goal_ids = []

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

      it "with duplicated code" do
        create :learning_objective, code: subject.code

        expect(subject).to_not be_valid
      end

      it 'without a curricular component' do
        subject.curricular_component_id = nil

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'default scope' do
    let!(:learning_objective_one) { create :learning_objective, code: 'EF02' }
    let!(:learning_objective_two) { create :learning_objective, code: 'EF01' }

    it 'orders by ascending code' do
      expect(LearningObjective.all).to eq([learning_objective_two, learning_objective_one])
    end
  end

  describe 'Methods' do
    context 'code must be in capital letter' do
      it 'on create' do
        subject.code = 'asdf2'

        expect(subject.code).to eq('ASDF2')
      end

      it 'on edit' do
        subject.save
        subject.code = 'newcode'

        expect(subject.code).to eq('NEWCODE')
      end
    end

    it 'return code and description' do
      subject.code = 'COD1'
      subject.description = 'Description'
      subject.save

      expect(subject.code_and_description).to eq('COD1 - Description')
    end
  end

  describe 'Queries' do
    before do
      create_list(:learning_objective, 4)
      create :learning_objective,
             curricular_component_id: c1.id
    end

    let(:all_response) { LearningObjective.all }
    let(:c1) { create :curricular_component }
    let(:params) { nil }

    context 'with curricular component' do
      let(:response) { LearningObjective.all_or_with_curricular_component(params) }
      let(:params) { c1.slug }

      it 'return all with none params' do
        params = nil
        response = LearningObjective.all_or_with_curricular_component(params)

        expect(all_response).to eq(response)
      end

      it 'include on response' do
        expect(response).to include(c1.learning_objectives.first)
      end

      it 'not include on response' do
        new_curricular_com = create :curricular_component
        create :learning_objective, curricular_component_id: new_curricular_com.id

        expect(response).to_not include(new_curricular_com.learning_objectives.first)
      end
    end

    context 'with year' do
      let(:params)   { { year: :second } }
      let(:response) { LearningObjective.all_or_with_year(params[:year]) }

      it 'return all with none params' do
        params = nil
        response = LearningObjective.all_or_with_year(params)

        expect(all_response).to eq(response)
      end

      it 'include' do
        a = create :learning_objective,
                   year: :second
        expect(response).to include(a)
      end

      it 'not include' do
        a = create :learning_objective,
                   year: :third
        expect(response).to_not include(a)
      end
    end
  end
end
