require 'rails_helper'

RSpec.describe Api::FiltersController, type: :controller do
  describe 'GET #activity_sequence_index' do
    it 'returns http success' do
      get :activity_sequence_index
      expect(response).to have_http_status(:success)
    end
  end
end
