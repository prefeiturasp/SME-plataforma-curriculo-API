require 'rails_helper'

RSpec.describe Api::FiltersController, type: :controller do
  let(:json) { JSON.parse(response.body) }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #index' do
    context 'returns http no content' do
      it 'returns no content' do
        get :index

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
      end

      context 'without optional params' do
        it 'returns http success' do
          get :index

          expect(response.content_type).to eq('application/json')
          expect(response).to be_successful
        end

        it 'return valid JSON all filters' do
          get :index

          expect(json['segments']).to be_present
          expect(json['curricular_components']).to be_present
          expect(json['sustainable_development_goals']).to be_present
          expect(json['knowledge_matrices']).to be_present
          expect(json['activity_types']).to_not be_present
          expect(json['learning_objectives']).to_not be_present
          expect(json['axes']).to be_present
        end

        it 'return valid segments JSON' do
          get :index

          expect(json['segments']).to be_present
          expect(json['segments'][0]['id']).to be_present
          expect(json['segments'][0]['name']).to be_present
          expect(json['segments'][0]['color']).to be_present
        end

        it 'return valid curricular components JSON' do
          get :index

          expect(json['curricular_components']).to be_present
          expect(json['curricular_components'][0]['slug']).to be_present
          expect(json['curricular_components'][0]['name']).to be_present
          expect(json['curricular_components'][0]['color']).to be_present
        end

        it 'return valid sustainable development goals JSON' do
          get :index

          expect(json['sustainable_development_goals']).to be_present
          expect(json['sustainable_development_goals'][0]['id']).to be_present
          expect(json['sustainable_development_goals'][0]['sequence']).to be_present
          expect(json['sustainable_development_goals'][0]['name']).to be_present
        end

        it 'return valid knowledge matrices JSON' do
          get :index

          expect(json['knowledge_matrices']).to be_present
          expect(json['knowledge_matrices'][0]['id']).to be_present
          expect(json['knowledge_matrices'][0]['sequence']).to be_present
          expect(json['knowledge_matrices'][0]['title']).to be_present
        end

        it 'not return activity types JSON' do
          get :index

          expect(json['activity_types']).to_not be_present
        end

        it 'invalid number semgent' do
          get :index, params: { segment_id: 9999 }

          expect(json['learning_objectives']).to_not be_present
        end

        it 'invalid curricular component' do
          get :index, params: { curricular_component_slug: 'invalid-slug' }

          expect(json['axes']).to be_present # show all
          expect(json['learning_objectives']).to_not be_present
        end
      end

      context 'with optional params' do
        let(:curricular_component) { create :curricular_component }
        let(:learning_objective) { create :learning_objective, curricular_component_id: curricular_component.id }
        let!(:axis) { create :axis, curricular_component_id: curricular_component.id }

        let(:params) do
          {
            segment_id: [learning_objective.segment_id],
            curricular_component_slugs: [curricular_component.slug]
          }
        end

        it 'return valid all JSON' do
          get :index, params: params

          expect(json['segments']).to be_present
          expect(json['curricular_components']).to be_present
          expect(json['sustainable_development_goals']).to be_present
          expect(json['knowledge_matrices']).to be_present
          expect(json['activity_types']).to_not be_present
          expect(json['learning_objectives']).to be_present
          expect(json['axes']).to be_present
        end

        it 'return valid axes JSON' do
          get :index, params: params

          expect(json['axes']).to be_present
          expect(json['axes'][0]['id']).to be_present
          expect(json['axes'][0]['description']).to be_present
        end

        it 'return valid learning objectives JSON' do
          get :index, params: params

          expect(json['learning_objectives']).to be_present
          expect(json['learning_objectives'][0]['id']).to be_present
          expect(json['learning_objectives'][0]['code']).to be_present
          expect(json['learning_objectives'][0]['description']).to be_present
        end
      end
    end
  end
end
