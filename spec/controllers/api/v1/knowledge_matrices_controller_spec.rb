require 'rails_helper'

RSpec.describe Api::V1::KnowledgeMatricesController, type: :controller do

  let(:valid_attributes) do
    attributes_for :knowledge_matrix
  end

  let(:invalid_attributes) do
    attributes_for :knowledge_matrix, title: nil
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      knowledge_matrix = KnowledgeMatrix.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      knowledge_matrix = KnowledgeMatrix.create! valid_attributes
      get :show, params: { id: knowledge_matrix.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new KnowledgeMatrix' do
        expect {
          post :create, params: { knowledge_matrix: valid_attributes }, session: valid_session
        }.to change(KnowledgeMatrix, :count).by(1)
      end

      it 'renders a JSON response with the new knowledge_matrix' do
        post :create, params: { knowledge_matrix: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new knowledge_matrix' do
        post :create, params: { knowledge_matrix: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :knowledge_matrix, title: "New Title",
        know_description: "New Saber",
        for_description: "New Para",
        sequence: 1001
      end

      it 'updates the requested knowledge_matrix' do
        knowledge_matrix = KnowledgeMatrix.create! valid_attributes
        put :update, params: { id: knowledge_matrix.to_param, knowledge_matrix: new_attributes }, session: valid_session
        knowledge_matrix.reload
        expect(knowledge_matrix.title).to eq('New Title')
        expect(knowledge_matrix.know_description).to eq('New Saber')
        expect(knowledge_matrix.for_description).to eq('New Para')
        expect(knowledge_matrix.sequence).to eq(1001)
      end

      it 'renders a JSON response with the knowledge_matrix' do
        knowledge_matrix = KnowledgeMatrix.create! valid_attributes

        put :update, params: { id: knowledge_matrix.to_param, knowledge_matrix: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the knowledge_matrix' do
        knowledge_matrix = KnowledgeMatrix.create! valid_attributes

        put :update, params: { id: knowledge_matrix.to_param, knowledge_matrix: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested knowledge_matrix' do
      knowledge_matrix = KnowledgeMatrix.create! valid_attributes
      expect {
        delete :destroy, params: { id: knowledge_matrix.to_param }, session: valid_session
      }.to change(KnowledgeMatrix, :count).by(-1)
    end
  end
end
