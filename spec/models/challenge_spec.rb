require 'rails_helper'

RSpec.describe Challenge, type: :model do
  include_examples 'image_concern'

  let(:subject) { build :challenge }

  describe 'Associations' do
    it 'has and belongs to many learning_objectives' do
      should have_and_belong_to_many(:learning_objectives)
    end

    it 'has many axes' do
      should have_many(:axes)
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
        new_object = build :challenge, title: subject.title

        expect(new_object).to_not be_valid
      end

      it 'without finish_at' do
        subject.finish_at = nil

        expect(subject).to_not be_valid
      end

      it 'without category' do
        subject.category = nil

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'methods' do

  end

  it_behaves_like 'image_concern'
end
