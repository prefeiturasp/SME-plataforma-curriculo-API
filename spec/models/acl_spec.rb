require 'rails_helper'

RSpec.describe Acl, type: :model do
  describe 'Associations' do
    it 'belongs to teacher' do
      should belong_to(:teacher)
    end
  end
end
