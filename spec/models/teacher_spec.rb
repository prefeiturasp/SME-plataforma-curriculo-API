require 'rails_helper'

RSpec.describe Teacher, type: :model do

  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    let(:subject) { build :teacher }

    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'contains avatar' do
        expect(subject.avatar).to be_an_instance_of(ActiveStorage::Attached::One)
      end

    end

    context 'is not valid' do

      it 'if user_id is null' do
        subject.user_id = nil

        expect(subject).to_not be_valid
      end

      it 'if nickname greather than 15 digits' do
        subject.nickname = Faker::Internet.user_name(16..20)

        expect(subject).to_not be_valid
      end
    end
  end
end
