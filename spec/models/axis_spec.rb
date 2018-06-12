require 'rails_helper'

RSpec.describe Axis, type: :model do
  let(:subject) { build :axis }

  describe 'Associations' do
    it { should belong_to(:curricular_component) }
  end

  describe 'Validations' do
    describe 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'if curricular components must exists' do
        should validate_presence_of(:curricular_component).with_message(:required)
      end
    end

    describe 'is not valid' do
      it 'without a description' do
        subject.description = nil

        expect(subject).to_not be_valid
      end

      it 'without a year' do
        subject.year = nil

        expect(subject).to_not be_valid
      end

      it 'if the description already exists' do
        subject.save
        subject.reload
        new_subject = build :axis, description: subject.description

        expect(new_subject).to_not be_valid
      end

      it 'if curricular components is null' do
        invalid_subject = build :axis, :invalid_curricular_component

        expect(invalid_subject).to_not be_valid
      end
    end
  end

  describe 'Queries' do
    before do
      create_list(:axis, 4)
      create :axis,
             curricular_component_id: c1.id
    end

    let(:all_response) { Axis.all }
    let(:c1) { create :curricular_component }
    let(:params) { nil }

    context 'with curricular component' do
      let(:response) { Axis.all_or_with_curricular_component(params) }
      let(:params) { c1.slug }

      it 'return all with none params' do
        params = nil
        response = Axis.all_or_with_curricular_component(params)

        expect(all_response).to eq(response)
      end

      it 'include on response' do
        expect(response).to include(c1.axes.first)
      end

      it 'not include on response' do
        new_curricular = create :curricular_component
        create :axis, curricular_component_id: new_curricular.id

        expect(response).to_not include(new_curricular.axes.first)
      end
    end

    context 'with year' do
      let(:params)   { { year: :second } }
      let(:response) { Axis.all_or_with_year(params[:year]) }

      it 'return all with none params' do
        params = nil
        response = Axis.all_or_with_year(params)

        expect(all_response).to eq(response)
      end

      it 'include' do
        a = create :axis,
                   year: :second
        expect(response).to include(a)
      end

      it 'not include' do
        a = create :axis,
                   year: :third
        expect(response).to_not include(a)
      end
    end
  end
end
