require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  login_superadmin

  let(:valid_attributes) do
    attributes_for(:activity_type)
  end

  let(:invalid_attributes) do
    attributes_for(:activity_type, :invalid_name)
  end

  describe 'GET #index' do
    context 'logged users' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'unlogged users' do
      it 'returns redirect to new session response' do
        user = create :user
        sign_in user

        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
