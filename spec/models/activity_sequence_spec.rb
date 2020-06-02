require 'rails_helper'
include Api::Concerns::ActivitySequenceSearchable

RSpec.describe ActivitySequence, type: :model do

  include_examples 'image_concern'

  describe 'Associations' do
    it 'belongs to main curricular component' do
      should belong_to(:main_curricular_component)
    end

    it 'belongs to segment' do
      should belong_to(:segment)
    end

    it 'belongs to stage' do
      should belong_to(:stage)
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

    context 'already saved in collection' do
      let(:teacher) { create :teacher }
      let(:activity_sequence) { create :activity_sequence }

      it 'return true if saved in some collection' do
        collection = create :collection, teacher: teacher
        create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

        expect(activity_sequence.already_saved_in_collection?(teacher)).to be true
      end

      it 'return false if not saved in collections' do
        expect(activity_sequence.already_saved_in_collection?(teacher)).to be false
      end
    end
  end

  it_behaves_like 'image_concern'
end
