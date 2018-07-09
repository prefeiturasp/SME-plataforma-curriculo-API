require 'rails_helper'

RSpec.describe CurricularComponent, type: :model do
  let(:subject) { build :curricular_component }

  describe 'Associations' do
    it 'has many axes' do
      should have_many(:axes)
    end

    it 'has many learning objectives' do
      should have_many(:learning_objectives)
    end

    it 'has and belongs to many activity sequences' do
      should have_and_belong_to_many(:activity_sequences)
    end

    it 'has many main activity sequences' do
      should have_many(:main_activity_sequences)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is invalid' do
      it 'is not valid without a name' do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it 'is not valid without a color' do
        subject.color = nil

        expect(subject).to_not be_valid
      end

      it 'is not valid if the name already exists' do
        subject.save
        new_object = build :curricular_component, name: subject.name

        expect(new_object).to_not be_valid
      end

      it 'is not valid if the color already exists' do
        subject.save
        new_object = build :curricular_component, color: subject.color

        expect(new_object).to_not be_valid
      end
    end

    context 'slug' do
      it 'should generate a slug' do
        subject.name = 'Hello World'
        subject.save

        expect(subject.slug).to eq('hello-world')
      end
    end
  end
end
