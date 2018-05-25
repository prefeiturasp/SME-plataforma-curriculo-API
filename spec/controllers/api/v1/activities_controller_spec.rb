require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :controller do

  let(:valid_attributes) do
    attributes_for :activity, activity_sequence_id: create(:activity_sequence)
  end

  let(:invalid_attributes) do
    attributes_for :activity, :invalid
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      activity = create :activity
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      activity = create :activity
      get :show, params: { id: activity.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Activity' do
        expect {
          post :create, params: { activity: valid_attributes }, session: valid_session
        }.to change(Activity, :count).by(1)
      end

      it 'renders a JSON response with the new activity' do
        post :create, params: { activity: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new activity' do
        post :create, params: { activity: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
          attributes_for :activity,
            title: 'New Title',
            estimated_time: 1001,
            content: 'New Content',
            activity_sequence_id: create(:activity_sequence).id
      end

      it 'updates the requested activity' do
        activity = create :activity
        put :update, params: { id: activity.to_param, activity: new_attributes }, session: valid_session
        activity.reload

        expect(activity.title).to eq('New Title')
        expect(activity.content).to eq('New Content')
      end

      it 'renders a JSON response with the activity' do
        activity = create :activity

        put :update, params: { id: activity.to_param, activity: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the activity' do
        activity = create :activity

        put :update, params: { id: activity.to_param, activity: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested activity' do
      activity = create :activity
      expect {
        delete :destroy, params: { id: activity.to_param }, session: valid_session
      }.to change(Activity, :count).by(-1)
    end
  end
end
