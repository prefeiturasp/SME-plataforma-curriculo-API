require 'rails_helper'

RSpec.describe Api::FiltersController, type: :controller do
  let(:json) { JSON.parse(response.body) }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #activity_sequence_index' do
    context 'returns http no content' do
      it 'returns no content' do
        get :activity_sequence_index

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'returns http success' do
      before do
        create :curricular_component
        create :sustainable_development_goal
        create :learning_objective
        create :knowledge_matrix
        create :axis
        create :activity_type
      end

      it 'returns http success' do
        get :activity_sequence_index

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all filters' do
        get :activity_sequence_index

        expect(json['years']).to be_present
        expect(json['curricular_components']).to be_present
        expect(json['sustainable_development_goals']).to be_present
        expect(json['knowledge_matrices']).to be_present
        expect(json['learning_objectives']).to be_present
        expect(json['axes']).to be_present
        expect(json['activity_types']).to be_present
      end

      it 'return valid years JSON' do
        get :activity_sequence_index

        expect(json['years']).to be_present
        expect(json['years'].length).to eq(3)
        expect(json['years'][0]['id']).to be_present
        expect(json['years'][0]['description']).to be_present
      end

      it 'return valid curricular components JSON' do
        get :activity_sequence_index

        expect(json['curricular_components']).to be_present
        expect(json['curricular_components'][0]['id']).to be_present
        expect(json['curricular_components'][0]['name']).to be_present
      end

      it 'return valid sustainable development goals JSON' do
        get :activity_sequence_index

        expect(json['sustainable_development_goals']).to be_present
        expect(json['sustainable_development_goals'][0]['id']).to be_present
        expect(json['sustainable_development_goals'][0]['sequence']).to be_present
        expect(json['sustainable_development_goals'][0]['name']).to be_present
      end

      it 'return valid knowledge matrices JSON' do
        get :activity_sequence_index

        expect(json['knowledge_matrices']).to be_present
        expect(json['knowledge_matrices'][0]['id']).to be_present
        expect(json['knowledge_matrices'][0]['sequence']).to be_present
        expect(json['knowledge_matrices'][0]['title']).to be_present
      end

      it 'return valid learning objectives JSON' do
        get :activity_sequence_index

        expect(json['learning_objectives']).to be_present
        expect(json['learning_objectives'][0]['id']).to be_present
        expect(json['learning_objectives'][0]['code']).to be_present
        expect(json['learning_objectives'][0]['description']).to be_present
      end

      it 'return valid axes JSON' do
        get :activity_sequence_index

        expect(json['axes']).to be_present
        expect(json['axes'][0]['id']).to be_present
        expect(json['axes'][0]['description']).to be_present
      end

      it 'return valid activity types JSON' do
        get :activity_sequence_index

        expect(json['activity_types']).to be_present
        expect(json['activity_types'][0]['id']).to be_present
        expect(json['activity_types'][0]['name']).to be_present
      end
    end
  end

  describe 'GET #activity_sequence_index_filter' do

    context 'with year params' do
      it 'invalid number year' do
        get :activity_sequence_index_filter, params: { year: 9999 }

        expect(response).to be_successful
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'invalid year to type string' do
        get :activity_sequence_index_filter, params: { year: :invalid_year }

        expect(response).to be_successful
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns http success' do
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter, params: { year: axis.year }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid axes JSON' do
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter, params: { year: axis.year }

        expect(json['axes']).to be_present
        expect(json['axes'][0]['id']).to be_present
        expect(json['axes'][0]['description']).to be_present
      end

      it 'return valid learning objectives JSON' do
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter, params: { year: axis.year }

        expect(json['learning_objectives']).to be_present
        expect(json['learning_objectives'][0]['id']).to be_present
        expect(json['learning_objectives'][0]['code']).to be_present
        expect(json['learning_objectives'][0]['description']).to be_present
      end

      it 'return without unecessary params' do
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter, params: { year: axis.year }

        expect(json['years']).to_not be_present
        expect(json['curricular_components']).to_not be_present
        expect(json['sustainable_development_goals']).to_not be_present
        expect(json['knowledge_matrices']).to_not be_present
        expect(json['activity_types']).to_not be_present
      end

    end

    context 'with year and curricular_component' do
      it 'returns no content with invalid slug' do
        curricular_component = create :curricular_component
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter,
            params: {
              year: axis.year,
              curricular_component_friendly_id: 'invalid-slug'
            }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end

      it 'returns http success' do
        curricular_component = create :curricular_component
        axis = create :axis
        create :learning_objective

        get :activity_sequence_index_filter,
            params: {
              year: axis.year,
              curricular_component_friendly_id: curricular_component.friendly_id
            }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid axes JSON' do
        curricular_component = create :curricular_component
        axis = create :axis, year: :first, curricular_component: curricular_component

        get :activity_sequence_index_filter,
            params: {
              year: axis.year,
              curricular_component_friendly_id: curricular_component.friendly_id
            }

        expect(json['axes']).to be_present
        expect(json['axes'][0]['id']).to be_present
        expect(json['axes'][0]['description']).to be_present
      end

      it 'return valid learning objectives JSON' do
        curricular_component = create :curricular_component
        learning_objective = create :learning_objective, year: :first, curricular_component: curricular_component

        get :activity_sequence_index_filter,
            params: {
              year: learning_objective.year,
              curricular_component_friendly_id: curricular_component.friendly_id
            }

        expect(json['learning_objectives']).to be_present
        expect(json['learning_objectives'][0]['id']).to be_present
        expect(json['learning_objectives'][0]['code']).to be_present
        expect(json['learning_objectives'][0]['description']).to be_present
      end
    end
  end
end
