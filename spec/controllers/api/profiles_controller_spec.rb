require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #me' do
    let(:user) { create :user }
    context 'with logged users' do
      before do
        authenticate_user user
      end

      it 'returns http success' do
        get :me

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'returns http ok' do
        get :me

        expect(response).to have_http_status(:ok)
      end

      it 'return valid JSON if user not is a teacher' do
        get :me

        expect(response_body['email']).to be_present
        expect(response_body['username']).to be_present
      end

      context 'with user has teacher' do
        it 'return key teacher on JSON response' do
          create :teacher, user: user

          get :me

          expect(response_body['teacher']).to be_present
          expect(response_body['teacher']['id']).to be_present
          expect(response_body['teacher']['name']).to be_present
          expect(response_body['teacher']['nickname']).to be_present
          expect(response_body['teacher']['number_of_sequences_not_evaluated']).to be_present
          expect(response_body['teacher']['avatar_attributes']).to be_present
          # TODO: Remove comment from the line below when classes are implemented
          # expect(response_body['teacher']['number_of_classes']).to be_present
          # expect(response_body['teacher']['number_of_components']).to be_present
        end
      end
    end

    context 'with unauthenticated users' do
      it 'returns http unauthorized' do
        get :me

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
