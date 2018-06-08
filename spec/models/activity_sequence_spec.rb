require 'rails_helper'

RSpec.describe ActivitySequence, type: :model do
  include_examples 'image_concern'

  describe 'Associations' do
    it 'belongs to main curricular component' do
      should belong_to(:main_curricular_component)
    end

    it 'has and belongs to many curricular components' do
      should have_and_belong_to_many(:curricular_components)
    end

    it 'has and belongs to many sustainable development goals' do
      should have_and_belong_to_many(:sustainable_development_goals)
    end

    it 'has and belongs to many knowledge matrices' do
      should have_and_belong_to_many(:knowledge_matrices)
    end

    it 'has and belongs to many learning objectives' do
      should have_and_belong_to_many(:learning_objectives)
    end
  end

  describe 'Validations' do
    let(:subject) { build :activity_sequence }

    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a title' do
        subject.title = nil

        expect(subject).to_not be_valid
      end

      it 'if the title already exists' do
        subject.save
        new_object = build :activity_sequence, title: subject.title

        expect(new_object).to_not be_valid
      end

      it 'without a year' do
        subject.year = nil

        expect(subject).to_not be_valid
      end

      it 'without a presentation text' do
        subject.presentation_text = nil

        expect(subject).to_not be_valid
      end

      it 'without a estimated time' do
        subject.estimated_time = nil

        expect(subject).to_not be_valid
      end

      it 'without a status' do
        subject.status = nil

        expect(subject).to_not be_valid
      end

      it 'without a learning objectives' do
        subject.learning_objectives.destroy_all

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Queries' do
    before do
      create_list(:activity_sequence, 4)
      create :activity_sequence,
      curricular_component_ids: [c1.id]
    end

    let(:all_response) { ActivitySequence.all }
    let(:c1) { create :curricular_component }
    let(:params) { {} }

    context 'with curricular component' do
      let(:response) { ActivitySequence.all_or_with_curricular_component(params) }
      let(:params) { {curricular_component_friendly_id: c1.slug } }

      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_curricular_component

        expect(all_response).to eq(response)
      end

      it 'include on response' do
        expect(response).to include(c1.activity_sequences.first)
      end

      it 'not include on response' do
        c2 = create :curricular_component
        create :activity_sequence, curricular_component_ids: [c2.id]

        expect(response).to_not include(c2.activity_sequences.last)
      end
    end

    context 'with year' do
      let(:params)   { { year: :second } }
      let(:response) { ActivitySequence.all_or_with_year(params[:year]) }

      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_year

        expect(all_response).to eq(response)
      end

      it 'include' do
        a = create :activity_sequence,
          year: :second
        expect(response).to include(a)
      end

      it 'not include' do
        a = create :activity_sequence,
          year: :third
        expect(response).to_not include(a)
      end
    end

    context 'with axes' do
      let(:axis) { create :axis, year: :second }
      let(:params) { { axis_id: axis.id, year: :second } }
      let(:response) { ActivitySequence.all_or_with_axes(params) }

      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_axes

        expect(all_response).to eq(response)
      end

      it 'include axis and year' do
        c2 = create :curricular_component, axis_ids: [axis.id]
        a = create :activity_sequence, curricular_component_ids: [c2.id]

        expect(response).to include(a)
      end

      it 'not include axis id' do
        axis_2 = create :axis
        c2 = create :curricular_component, axis_ids: [axis_2.id]
        a = create :activity_sequence, curricular_component_ids: [c2.id]

        expect(response).to_not include(a)
      end

      it 'not include year' do
        axis_2 = create :axis, year: :third
        c2 = create :curricular_component, axis_ids: [axis_2.id]
        a = create :activity_sequence, curricular_component_ids: [c2.id]

        expect(response).to_not include(a)
      end
    end

    context 'with sustainable development goal' do
      let(:sdg) { create :sustainable_development_goal }
      let(:params) { { sustainable_development_goal_id: sdg.id } }
      let(:response) { response = ActivitySequence.all_or_with_sustainable_development_goal(params) }
      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_sustainable_development_goal

        expect(all_response).to eq(response)
      end

      it 'include sustainable development goals' do
        a = create :activity_sequence, sustainable_development_goal_ids: [sdg.id]

        expect(response).to include(a)
      end

      it 'not include sustainable development goals' do
        other_sdg = create :sustainable_development_goal
        a = create :activity_sequence, sustainable_development_goal_ids: [other_sdg.id]

        expect(response).to_not include(a)
      end
    end

    context 'with knowledge matrix' do
      let(:knowledge_matrix) { create :knowledge_matrix }
      let(:params) { { knowledge_matrix_id: knowledge_matrix.id } }
      let(:response) { response = ActivitySequence.all_or_with_knowledge_matrices(params) }
      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_knowledge_matrices

        expect(all_response).to eq(response)
      end

      it 'include knowledge matrix' do
        a = create :activity_sequence, knowledge_matrix_ids: [knowledge_matrix.id]

        expect(response).to include(a)
      end

      it 'not include knowledge matrix' do
        other_knowledge_matrix = create :knowledge_matrix
        a = create :activity_sequence, knowledge_matrix_ids: [other_knowledge_matrix.id]

        expect(response).to_not include(a)
      end
    end

    context 'with learning objectives' do
      let(:learning_objective) { create :learning_objective }
      let(:params) { { learning_objective_id: learning_objective.id } }
      let(:response) { response = ActivitySequence.all_or_with_learning_objectives(params) }
      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_learning_objectives

        expect(all_response).to eq(response)
      end

      it 'include learning objectives' do
        a = create :activity_sequence, learning_objective_ids: [learning_objective.id]

        expect(response).to include(a)
      end

      it 'not include learning objectives' do
        other_learning_objective = create :learning_objective
        a = create :activity_sequence, learning_objective_ids: [other_learning_objective.id]

        expect(response).to_not include(a)
      end
    end

    context 'with activity types' do
      let(:activity_type) { create :activity_type }
      let(:activity) { create :activity, activity_type_ids: [activity_type.id] }

      let(:params) { { activity_type_id: activity_type.id } }
      let(:response) { response = ActivitySequence.all_or_with_activity_types(params) }
      it 'return all with none params' do
        params = nil
        response = ActivitySequence.all_or_with_activity_types

        expect(all_response).to eq(response)
      end

      it 'include activity types' do
        a = create :activity_sequence, activity_ids: [activity.id]

        expect(response).to include(a)
      end

      it 'not include activity types' do
        other_activity_type = create :activity_type
        other_activity = create :activity, activity_type_ids: [other_activity_type.id]
        a = create :activity_sequence, activity_ids: [other_activity.id]

        expect(response).to_not include(a)
      end
    end

  end

  it_behaves_like 'image_concern'
end
