require 'rails_helper'

RSpec.describe Api::V1::SegmentsController, type: :controller do
  let(:valid_attributes) do
    attributes_for(:segment)
  end

  let(:invalid_attributes) do
    attributes_for(:segment, name: nil)
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
      segment = create :segment
      get :show, params: { id: segment.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Segment' do
        expect {
          post :create, params: { segment: valid_attributes }, session: valid_session
        }.to change(Segment, :count).by(1)
      end

      it 'renders a JSON response with the new segment' do
        post :create, params: { segment: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new segment' do
        post :create, params: { segment: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:segment, name: 'New Segment')
      end

      it 'updates the requested segment' do
        segment = create :segment
        put :update, params: { id: segment.to_param, segment: new_attributes }, session: valid_session
        segment.reload

        expect(segment.name).to eq('New Segment')
      end

      it 'renders a JSON response with the segment' do
        segment = create :segment

        put :update, params: { id: segment.to_param, segment: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the segment' do
        segment = create :segment

        put :update, params: { id: segment.to_param, segment: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested segment' do
      segment = create :segment
      expect {
        delete :destroy, params: { id: segment.to_param }, session: valid_session
      }.to change(Segment, :count).by(-1)
    end
  end
end
