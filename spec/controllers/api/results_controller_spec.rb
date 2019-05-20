require 'rails_helper'

RSpec.describe Api::ResultsController, type: :controller do
  let(:response_body) { JSON.parse response.body }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #show' do
    let(:result) do
      create :result
    end

    context 'returns http no content' do
      it 'returns no content' do
        get :show, params: { challenge_slug: result.challenge.slug, id: 0 }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http success' do
      it 'returns http success' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response_body['class_name']).to  be_present
        expect(response_body['description']).to be_present
        expect(response_body['created_at']).to  be_present
      end

      it 'return valid teacher JSON' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response_body['teacher']).to be_present
        expect(response_body['teacher']['name']).to be_present
      end

      it 'return list of links JSON' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response_body['links']).to be_present
        expect(response_body['links'][0]).to be_present
      end

      it 'return list of images JSON' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response_body['images']).to be_present
      end

      it 'return list of documents JSON' do
        get :show, params: { challenge_slug: result.challenge.slug, id: result.id }

        expect(response_body['documents']).to be_present
      end
    end
  end
end
