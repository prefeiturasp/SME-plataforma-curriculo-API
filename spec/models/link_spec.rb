require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:subject) { build :link }

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a link' do
        subject.link = "not-valid-url"

        expect(subject).to_not be_valid
      end
    end
  end
end
