require 'rails_helper'

RSpec.describe ChallengeContentBlock, type: :model do
  describe 'Associations' do
    it 'belongs to challenge' do
      should belong_to(:challenge)
    end

    it 'belongs to content block' do
      should belong_to(:content_block)
    end

    it 'has many images' do
      should have_many(:images)
    end
  end
end
