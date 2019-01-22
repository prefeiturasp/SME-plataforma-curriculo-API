require 'rails_helper'

RSpec.describe ActivitySequence, type: :model do
  include_examples 'image_concern'

  describe 'Associations' do
    it 'belongs to main curricular component' do
      should belong_to(:main_curricular_component)
    end

    it 'has and belongs to many knowledge matrices' do
      should have_and_belong_to_many(:knowledge_matrices)
    end

    it 'has and belongs to many learning objectives' do
      should have_and_belong_to_many(:learning_objectives)
    end

    it 'has many collection activity sequences' do
      should have_many(:collection_activity_sequences)
    end

    it 'has many collections' do
      should have_many(:collections)
    end
  end

  context 'slug' do
    it 'should generate a slug' do
      subject = create :activity_sequence, title: 'Hello World'

      expect(subject.slug).to eq('hello-world')
    end
  end

  describe 'Validations' do
    let(:subject) { build :activity_sequence }

    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'without a estimated time' do
        subject.estimated_time = nil

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

  describe 'Curricular components' do
    let(:curricular_component) { create :curricular_component }
    let(:activity) { create :activity, curricular_component_ids: [curricular_component.id] }
    context 'list' do
      it 'with has many of my activities' do
        activity_sequence = create :activity_sequence, activity_ids: [activity.id]

        expect(activity_sequence.curricular_components).to include(curricular_component)
      end
    end

    context 'not list' do
      it 'with not exists of my activities' do
        new_curricular_com = create :curricular_component
        activity_sequence = create :activity_sequence, activity_ids: [activity.id]

        expect(activity_sequence.curricular_components).to_not include(new_curricular_com)
      end
    end
  end

  describe 'Sustainable Development Goals' do
    let(:sustainable_development_goal) { create :sustainable_development_goal }
    let(:learning_objective) do
      create :learning_objective,
             sustainable_development_goal_ids: [sustainable_development_goal.id]
    end
    context 'list' do
      it 'with learning_objective has this sustainable_development_goal' do
        activity_sequence = create :activity_sequence, learning_objective_ids: [learning_objective.id]

        expect(activity_sequence.sustainable_development_goals).to include(sustainable_development_goal)
      end
    end

    context 'not list' do
      it 'with not exists of learning_objective' do
        new_sdg = create :sustainable_development_goal
        activity_sequence = create :activity_sequence, learning_objective_ids: [learning_objective.id]

        expect(activity_sequence.learning_objectives).to_not include(new_sdg)
      end
    end
  end

  describe 'Queries' do
    let(:c1) { create :curricular_component }

    before do
      create_list(:activity_sequence, 4)
      create :activity_sequence,
             main_curricular_component_id: c1.id
    end

    let(:all_response) { ActivitySequence.all }
    let(:params) { {} }

    context 'with main curricular component' do
      let(:response) { ActivitySequence.all_or_with_main_curricular_component(params) }
      let(:params) { { curricular_component_slugs: c1.slug } }

      it 'return all with none params' do
        response = ActivitySequence.all_or_with_main_curricular_component

        expect(all_response).to eq(response)
      end

      it 'include on response' do
        c1.reload
        expect(response).to include(c1.main_activity_sequences.first)
      end
    end

    context 'with year' do
      let(:params)   { { year: :second } }
      let(:response) { ActivitySequence.all_or_with_year(params[:year]) }

      it 'return all with none params' do
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
      let(:curricular_component) { create :curricular_component }
      let(:axis) { create :axis, curricular_component: curricular_component }
      let(:params) { { axis_ids: axis.id } }
      let(:response) { ActivitySequence.all_or_with_axes(params) }

      it 'return all, if there are no params' do
        response = ActivitySequence.all_or_with_axes

        expect(all_response).to eq(response)
      end

      it 'return activity sequence, if axis exists on learning objectives' do
        learning_objective = create :learning_objective, axes: [axis], curricular_component: curricular_component
        activity_sequence = create :activity_sequence, learning_objectives: [learning_objective]

        expect(response).to include(activity_sequence)
      end

      it 'NOT return activity sequence, if axis NOT exists on learning objectives' do
        learning_objective = create :learning_objective, curricular_component: curricular_component
        activity_sequence = create :activity_sequence, learning_objectives: [learning_objective]

        expect(response).to_not include(activity_sequence)
      end
    end

    context 'with sustainable development goal' do
      let(:sdg) { create :sustainable_development_goal }
      let(:learning_objective) { create :learning_objective, sustainable_development_goal_ids: [sdg.id] }

      let(:params) { { sustainable_development_goal_ids: sdg.id } }
      let(:response) { ActivitySequence.all_or_with_sustainable_development_goal(params) }
      it 'return all with none params' do
        response = ActivitySequence.all_or_with_sustainable_development_goal

        expect(all_response).to eq(response)
      end

      it 'include sustainable development goals' do
        a = create :activity_sequence, learning_objective_ids: [learning_objective.id]

        expect(response).to include(a)
      end

      it 'not include sustainable development goals' do
        create :sustainable_development_goal
        other_learning_objective = create :learning_objective
        a = create :activity_sequence, learning_objective_ids: [other_learning_objective.id]

        expect(response).to_not include(a)
      end
    end

    context 'with knowledge matrix' do
      let(:knowledge_matrix) { create :knowledge_matrix }
      let(:params) { { knowledge_matrix_ids: knowledge_matrix.id } }
      let(:response) { ActivitySequence.all_or_with_knowledge_matrices(params) }
      it 'return all with none params' do
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
      let(:params) { { learning_objective_ids: learning_objective.id } }
      let(:response) { ActivitySequence.all_or_with_learning_objectives(params) }
      it 'return all with none params' do
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
  end

  describe 'Scope' do
    context 'evaluateds' do
      it 'returns those already evaluated' do
        activity_sequence_evaluated = create :activity_sequence
        create :activity_sequence_performed, evaluated: true, activity_sequence: activity_sequence_evaluated
        activity_sequence_not_evaluated = create :activity_sequence

        expect(ActivitySequence.evaluateds).to include(activity_sequence_evaluated)
        expect(ActivitySequence.evaluateds).to_not include(activity_sequence_not_evaluated)
      end
    end
  end

  describe 'Methods' do
    context 'total evaluations' do
      it 'return total' do
        activity_sequence = create :activity_sequence
        create_list(:activity_sequence_performed, 4, activity_sequence: activity_sequence, evaluated: true)

        expect(activity_sequence.total_evaluations).to eq(4)
      end
    end

    def average_by_rating_type(rating_id)
      activity_sequence_ratings.where(rating_id: rating_id).pluck(:score).mean
    end

    context 'average by rating type' do
      it 'returns mean' do
        rating = create :rating, enable: true
        activity_sequence = create :activity_sequence
        activity_sequence_performed = create :activity_sequence_performed, activity_sequence: activity_sequence
        activity_sequence_performed_2 = create :activity_sequence_performed, activity_sequence: activity_sequence
        create :activity_sequence_rating,
               activity_sequence_performed: activity_sequence_performed, rating: rating, score: 1
        create :activity_sequence_rating,
               activity_sequence_performed: activity_sequence_performed_2, rating: rating, score: 5

        # (5 + 1)/2 = 3
        expect(activity_sequence.average_by_rating_type(rating.id)).to eq(3)
      end
    end
  end

  it_behaves_like 'image_concern'
end
