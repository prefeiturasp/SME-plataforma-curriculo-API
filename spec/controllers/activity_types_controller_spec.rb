require 'rails_helper'

RSpec.describe Api::V1::ActivityTypesController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:activity_type)
  }

  let(:invalid_attributes) {
    attributes_for(:activity_type, :invalid_name)
  }

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      activity_type = create :activity_type
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      activity_type = create :activity_type
      get :show, params: {id: activity_type.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ActivityType' do
        expect {
          post :create, params: {activity_type: valid_attributes }, session: valid_session
        }.to change(ActivityType, :count).by(1)
      end

      it 'renders a JSON response with the new activity_type' do

        post :create, params: {activity_type: valid_attributes}, session: valid_session

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new activity_type' do

        post :create, params: {activity_type: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        attributes_for(:activity_type, name: 'New ActivityType Test')
      }

      it 'updates the requested activity_type' do
        activity_type = create :activity_type
        
        put :update, params: {id: activity_type.to_param, activity_type: new_attributes }, session: valid_session
        activity_type.reload

        expect(activity_type.name).to eq('New ActivityType Test')
      end

      it 'renders a JSON response with the activity_type' do
        activity_type = create :activity_type

        put :update, params: {id: activity_type.to_param, activity_type: new_attributes}, session: valid_session

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the activity_type' do
        activity_type = create :activity_type
        invalid_attributes = attributes_for(:activity_type, :invalid_name)

        put :update, params: {id: activity_type.to_param, activity_type: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested activity_type' do
      activity_type = create :activity_type
      expect {
        delete :destroy, params: {id: activity_type.to_param}, session: valid_session
      }.to change(ActivityType, :count).by(-1)
    end
  end

end
