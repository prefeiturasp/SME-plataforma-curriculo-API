require 'rails_helper'

RSpec.describe Api::V1::AxesController, type: :controller do
  let(:valid_attributes) do
    attributes_for(:axis, curricular_component_id: create(:curricular_component))
  end

  let(:invalid_attributes) do
    attributes_for(:axis, :invalid_description)
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
      axis = create :axis
      get :show, params: { id: axis.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Axis' do
        expect {
          post :create, params: { axis: valid_attributes }, session: valid_session
        }.to change(Axis, :count).by(1)
      end

      it 'renders a JSON response with the new axis' do
        post :create, params: { axis: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new axis' do
        post :create, params: { axis: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:axis, description: 'New Axis')
      end

      it 'updates the requested axis' do
        axis = create :axis
        put :update, params: { id: axis.to_param, axis: new_attributes }, session: valid_session
        axis.reload

        expect(axis.description).to eq('New Axis')
      end

      it 'renders a JSON response with the axis' do
        axis = create :axis

        put :update, params: { id: axis.to_param, axis: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the axis' do
        axis = create :axis

        put :update, params: { id: axis.to_param, axis: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested axis' do
      axis = create :axis
      expect {
        delete :destroy, params: { id: axis.to_param }, session: valid_session
      }.to change(Axis, :count).by(-1)
    end
  end
end
