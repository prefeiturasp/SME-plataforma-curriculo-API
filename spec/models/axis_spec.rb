require 'rails_helper'

RSpec.describe Axis, type: :model do
  let(:subject) { build :axis }

  describe 'Associations' do
    it { should belong_to(:curricular_component) }
  end

  describe 'Validations' do
    describe 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'if curricular components must exists' do
        should validate_presence_of(:curricular_component).with_message(:required)
      end
    end

    describe 'is not valid' do
      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'without a year' do
        subject.year = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        subject.reload
        new_subject = build :axis, description: subject.description

        expect(new_subject).to_not be_valid
      end

      it 'if curricular components is null' do
        invalid_subject = build :axis, :invalid_curricular_component

        expect(invalid_subject).to_not be_valid
      end
    end
  end
end
