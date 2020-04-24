require 'rails_helper'

RSpec.describe Api::V1::StagesController, type: :controller do
  let(:valid_attributes) do
    attributes_for(:stage, segment_id: create(:segment).id)
  end

  let(:invalid_attributes) do
    attributes_for(:stage, name: nil)
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      stage = create :stage
      get :show, params: { id: stage.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Stage' do
        expect {
          post :create, params: { stage: valid_attributes }, session: valid_session
        }.to change(Stage, :count).by(1)
      end

      it 'renders a JSON response with the new stage' do
        post :create, params: { stage: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new stage' do
        post :create, params: { stage: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:stage, name: 'New Stage')
      end

      it 'updates the requested stage' do
        stage = create :stage
        put :update, params: { id: stage.to_param, stage: new_attributes }, session: valid_session
        stage.reload

        expect(stage.name).to eq('New Stage')
      end

      it 'renders a JSON response with the stage' do
        stage = create :stage

        put :update, params: { id: stage.to_param, stage: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the stage' do
        stage = create :stage

        put :update, params: { id: stage.to_param, stage: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested stage' do
      stage = create :stage
      expect {
        delete :destroy, params: { id: stage.to_param }, session: valid_session
      }.to change(Stage, :count).by(-1)
    end
  end
end
