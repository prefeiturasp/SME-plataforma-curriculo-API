require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  let(:subject)  { build :activity_type }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil

    expect(subject).to_not be_valid
  end

  it 'is not valid if the name already exists' do
    subject.save
    new_object = build :activity_type, name: subject.name

    expect(new_object).to_not be_valid
  end
end