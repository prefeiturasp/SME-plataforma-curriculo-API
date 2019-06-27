require 'rails_helper'

RSpec.describe Api::FavouritesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #index' do
#    before do
#      authenticate_user user
#    end

    let(:favourite) do
      create :favourite
    end

    context 'returns http no content' do
      it 'returns no content' do
        get :index, params: { teacher_id: 999999999 }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http success' do
      it 'returns http success' do
        get :index, params: { teacher_id: favourite.teacher_id }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end
    end
  end
end
