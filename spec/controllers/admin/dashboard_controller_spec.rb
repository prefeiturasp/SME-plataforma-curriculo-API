require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  login_superadmin

  let(:valid_attributes) {
    attributes_for(:activity_type)
  }

  let(:invalid_attributes) {
    attributes_for(:activity_type, :invalid_name)
  }

  let(:valid_session) { {} }

  describe 'GET #index' do
    context 'logged users' do
      it 'returns a success response' do
        activity_type = create :activity_type

        get :index
        expect(response).to be_success
      end
    end

    context 'unlogged users' do
      it 'returns redirect to new session response' do
        user = create :user
        sign_in user

        activity_type = create :activity_type

        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end