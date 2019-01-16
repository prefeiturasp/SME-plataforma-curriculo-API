require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:subject) { build :rating }

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        new_object = build :rating, description: subject.description

        expect(new_object).to_not be_valid
      end
    end
  end
end
