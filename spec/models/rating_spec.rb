require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:subject) { build :rating }

  describe 'Associations' do
    it 'has many activity sequence ratings' do
      should have_many(:activity_sequence_ratings)
    end
  end

  describe 'Validations' do
    context 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        new_object = build :rating, description: subject.description

        expect(new_object).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'enableds' do
      let(:rating_1) { create :rating, enable: true }
      let(:rating_2) { create :rating, enable: false }
      let(:rating_3) { create :rating, enable: true }

      it 'List all if enable is true' do
        expect(Rating.enableds.include?(rating_1)).to eq(true)
        expect(Rating.enableds.include?(rating_3)).to eq(true)
      end

      it 'Not list if enable is false' do
        expect(Rating.enableds).to_not include(rating_2)
      end
    end
  end

  describe 'Methods' do
    it 'List all ids enabled' do
      rating_1 = create :rating, enable: true
      rating_2 = create :rating, enable: false
      rating_3 = create :rating, enable: true

      expected_array = [rating_1.id, rating_3.id].sort()

      expect(Rating.enabled_rating_ids).to eq(expected_array)
      expect(Rating.enabled_rating_ids).to_not include(rating_2)
    end
  end
end
