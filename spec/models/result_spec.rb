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
end
