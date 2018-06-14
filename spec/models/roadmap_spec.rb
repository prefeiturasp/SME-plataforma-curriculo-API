require 'rails_helper'

RSpec.describe Roadmap, type: :model do
  let(:subject) { build :roadmap }

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
        new_object = build :roadmap, title: subject.title

        expect(new_object).to_not be_valid
      end

      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        new_object = build :roadmap, description: subject.description

        expect(new_object).to_not be_valid
      end

      it 'without a status' do
        subject.status = nil

        expect(subject).to_not be_valid
      end
    end
  end
end
