require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  let(:subject) { build :activity_type }

  describe 'Associations' do
    it 'has and belongs to many' do
      should have_and_belong_to_many(:activities)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'valid without a name' do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it 'if the name already exists' do
        subject.save
        new_object = build :activity_type, name: subject.name

        expect(new_object).to_not be_valid
      end
    end
  end

  describe '#destroy' do
    let(:subject) { create :activity_type }

    context "without activities" do
      before do
        subject.destroy
      end

      it 'returns no errors' do
        expect(subject.errors[:activities]).to_not include(I18n.t('activerecord.errors.messages.restrict_dependent_destroy.has_many', record: Activity.model_name.human))
      end
    end

    context "with activities" do
      before do
        create :activity, activity_type_ids: [subject.id]
      end

      it 'returns errors' do
        subject.destroy
        expect(subject.errors[:activities]).to include(I18n.t('activerecord.errors.messages.restrict_dependent_destroy.has_many', record: Activity.model_name.human))
      end
    end
  end
end
