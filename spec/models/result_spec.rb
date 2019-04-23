require 'rails_helper'

RSpec.describe Result, type: :model do
  describe 'Associations' do
    it 'belongs to challenge' do
      should belong_to(:challenge)
    end

    it 'belongs to teacher' do
      should belong_to(:teacher)
    end

    it 'has many links' do
      should have_many(:links)
    end
  end

#  describe 'Validations' do
#    context 'is valid' do
#      it 'with valid attributes' do
#        expect(subject).to be_valid
#      end
#    end

#    context 'is not valid' do
#      it 'without a description' do
#        subject.link = "not-valid-url"

#        expect(subject).to_not be_valid
#      end
#    end
#  end
end
