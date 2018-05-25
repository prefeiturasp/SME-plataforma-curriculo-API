require 'rails_helper'

RSpec.describe ActivitySequence, type: :model do
  include_examples 'image_concern'
  let(:subject) { build :activity_sequence }

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

      it 'without a books' do
        subject.books = nil

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
    end
  end
  it_behaves_like 'image_concern'
end
