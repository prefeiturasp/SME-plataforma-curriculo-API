require 'rails_helper'

RSpec.describe Api::ActivitySequencesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }

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
        create :activity_sequence
      end

      it 'returns http success' do
        get :index

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all filters' do
        get :index

        expect(first_body['id']).to be_present
        expect(first_body['title']).to be_present
        expect(first_body['main_curricular_component']).to be_present
        expect(first_body['estimated_time']).to be_present
        expect(first_body['status']).to be_present
        expect(first_body['number_of_activities']).to be_present
        expect(first_body['image']).to be_present
        expect(first_body['knowledge_matrices']).to be_present
        expect(first_body['learning_objectives']).to be_present
        expect(first_body['sustainable_development_goals']).to be_present
      end

      it 'return valid knowledge matrices JSON' do
        get :index

        expect(first_body['knowledge_matrices']).to be_present
        expect(first_body['knowledge_matrices'][0]['sequence']).to be_present
        expect(first_body['knowledge_matrices'][0]['title']).to be_present
      end

      it 'return valid learning objectives JSON' do
        get :index

        expect(first_body['learning_objectives']).to be_present
        expect(first_body['learning_objectives'][0]['code']).to be_present
      end

      it 'return valid sustainable development goals JSON' do
        get :index

        expect(first_body['sustainable_development_goals']).to be_present
        expect(first_body['sustainable_development_goals'][0]['icon_url']).to be_present
      end
    end
  end
end
