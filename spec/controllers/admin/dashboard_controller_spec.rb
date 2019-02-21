require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe 'GET #index' do
    context 'logged users' do
      it 'returns a success response' do
        user = create :user
        sign_in user
        get :index
        expect(response).to be_successful
      end
    end

    context 'unlogged users' do
      it 'returns redirect to new session response' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
