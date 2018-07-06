require 'rails_helper'

RSpec.describe Api::SustainableDevelopmentGoalsController, type: :controller do
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
        expect(response).to have_http_status(:ok)
      end
    end

    context 'returns http success' do
      before do
        create :sustainable_development_goal
      end

      it 'returns http success' do
        get :index

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all filters' do
        get :index

        expect(first_body['sequence']).to be_present
        expect(first_body['name']).to be_present
        expect(first_body['icon']).to be_present
        expect(first_body['sub_icon']).to be_present
      end
    end
  end

  describe 'GET #show' do
    let(:goal) { create :goal }
    let(:sustainable_development_goal) { create :sustainable_development_goal,
      goal_ids: [goal.id]
    }

    context 'returns http no content' do
      it 'returns no content' do
        get :show, params: { id: 9999 }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http success' do
      it 'returns http success' do
        get :show, params: { id: sustainable_development_goal.id }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all' do
        get :show, params: { id: sustainable_development_goal.id }

        expect(response_body['id']).to be_present
        expect(response_body['sequence']).to be_present
        expect(response_body['name']).to be_present
        expect(response_body['description']).to be_present
        expect(response_body['icon']).to be_present
        expect(response_body['sub_icon']).to be_present
        expect(response_body['goals']).to be_present
        expect(response_body['color']).to be_present
      end

      it 'return valid Goals json' do
        get :show, params: { id: sustainable_development_goal.id }

        expect(response_body['goals']).to be_present
        expect(response_body['goals'][0]['description']).to be_present
      end
    end
  end
end
