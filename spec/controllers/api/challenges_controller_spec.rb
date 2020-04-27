require 'rails_helper'

RSpec.describe Api::ChallengesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #show' do
    let(:challenge) do
      create :challenge
    end

    context 'returns http no content' do
      it 'returns no content' do
        get :show, params: { slug: 'invalid-slug' }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http success' do
      it 'returns http success' do
        get :show, params: { slug: challenge.slug }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON' do
        get :show, params: { slug: challenge.slug }

        expect(response_body['slug']).to be_present
        expect(response_body['title']).to be_present
        expect(response_body['finish_at']).to be_present
        expect(response_body['keywords']).to be_present
        expect(response_body['category']).to be_present
        expect(response_body['status']).to be_present
      end

      it 'return valid curricular components JSON' do
        get :show, params: { slug: challenge.slug }

        expect(response_body['curricular_components']).to be_present
        expect(response_body['curricular_components'][0]['name']).to be_present
      end

      it 'return valid learning objectives JSON' do
        get :show, params: { slug: challenge.slug }

        expect(response_body['learning_objectives']).to be_present
        expect(response_body['learning_objectives'][0]['code']).to be_present
        expect(response_body['learning_objectives'][0]['description']).to be_present
        expect(response_body['learning_objectives'][0]['color']).to be_present
      end
    end
  end
end
