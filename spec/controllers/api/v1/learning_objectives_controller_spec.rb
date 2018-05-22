require 'rails_helper'

RSpec.describe Api::V1::LearningObjectivesController, type: :controller do
  let(:valid_attributes) do
    attributes_for :learning_objective,
                   curricular_component_id: create(:curricular_component),
                   sustainable_development_goal_ids: [create(:sustainable_development_goal)]
  end

  let(:invalid_attributes) do
    attributes_for :learning_objective, year: nil
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
      learning_objective = create :learning_objective
      get :show, params: { id: learning_objective.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new LearningObjective' do
        expect {
          post :create, params: { learning_objective: valid_attributes }, session: valid_session
        }.to change(LearningObjective, :count).by(1)
      end

      it 'renders a JSON response with the new learning_objective' do
        post :create, params: { learning_objective: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new learning_objective' do
        post :create, params: {
          learning_objective: invalid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :learning_objective, description: 'New Learning Objective Descritpion'
      end

      it 'updates the requested learning_objective' do
        learning_objective = create :learning_objective

        put :update, params: {
          id: learning_objective.to_param,
          learning_objective: new_attributes
        }, session: valid_session
        learning_objective.reload
        expect(learning_objective.description).to eq('New Learning Objective Descritpion')
      end

      it 'renders a JSON response with the learning_objective' do
        learning_objective = create :learning_objective

        put :update, params: {
          id: learning_objective.to_param,
          learning_objective: valid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the learning_objective' do
        learning_objective = create :learning_objective

        put :update, params: {
          id: learning_objective.to_param,
          learning_objective: invalid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested learning_objective' do
      learning_objective = create :learning_objective
      expect {
        delete :destroy, params: { id: learning_objective.to_param }, session: valid_session
      }.to change(LearningObjective, :count).by(-1)
    end
  end
end
