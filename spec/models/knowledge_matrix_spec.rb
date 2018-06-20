require 'rails_helper'

RSpec.describe KnowledgeMatrix, type: :model do
  include_examples 'sequence_concern_spec'
  let(:subject) { build :knowledge_matrix }

  describe 'Associations' do
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

    context 'is not valid' do
      it 'without a title' do
        subject.title = nil

        expect(subject).to_not be_valid
      end

      it 'without a know description' do
        subject.know_description = nil

        expect(subject).to_not be_valid
      end

      it 'without a for description' do
        subject.for_description = nil

        expect(subject).to_not be_valid
      end

      it 'without a sequence' do
        subject.sequence = nil

        expect(subject).to_not be_valid
      end

      it 'if the title already exists' do
        subject.save
        new_object = build :knowledge_matrix, title: subject.title

        expect(new_object).to_not be_valid
      end
    end
  end
  it_behaves_like 'sequence_concern_spec'
end
