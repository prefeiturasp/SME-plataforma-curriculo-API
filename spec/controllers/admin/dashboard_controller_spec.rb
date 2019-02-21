require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe 'GET #index' do
    context 'logged users' do
      context 'if is admin' do
        it 'returns a success response' do
          user = create :user, admin: true
          sign_in user

          get :index

          expect(response).to be_successful
        end
      end
      context 'if not is admin' do
        it 'returns redirect' do
          user = create :user, admin: false
          sign_in user

          get :index

          expect(response).to be_redirect
        end
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
