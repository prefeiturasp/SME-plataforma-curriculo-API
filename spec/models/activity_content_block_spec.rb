require 'rails_helper'

RSpec.describe ActivityContentBlock, type: :model do
  describe 'Associations' do
    it 'belongs to activity' do
      should belong_to(:activity)
    end

    it 'belongs to content block' do
      should belong_to(:content_block)
    end

    it 'has many iamges' do
      should have_many(:images)
    end
  end
end
