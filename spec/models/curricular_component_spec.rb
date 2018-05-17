require 'rails_helper'

RSpec.describe CurricularComponent, type: :model do
  let(:subject) { build :curricular_component }

  context 'is valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'is invalid' do
    it 'is not valid without a name' do
      subject.name = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid if the name already exists' do
      subject.save
      new_object = build :curricular_component, name: subject.name

      expect(new_object).to_not be_valid
    end
  end
end
