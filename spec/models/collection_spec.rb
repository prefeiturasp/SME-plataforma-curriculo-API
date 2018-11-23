require 'rails_helper'

RSpec.describe Collection, type: :model do

  let(:subject) { create :collection }

  describe 'Associations' do
    it 'belongs to teacher' do
      should belong_to(:teacher)
    end
  end

  describe 'Validations' do
    context "is valid" do
      it 'with valid params' do
        expect(subject).to be_valid
      end

      it 'with name length is equals 30 characters' do
        subject.name = Faker::Lorem.characters(30)

        expect(subject).to be_valid
      end
    end

    context 'is invalid' do
      it 'without a name' do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it 'if name greather than 30 characters' do
        subject.name = Faker::Lorem.characters(31)

        expect(subject).to_not be_valid
      end

      it 'if teacher is nil' do
        subject.teacher_id = nil

        expect(subject).to_not be_valid
      end
    end
  end
end
