require 'rails_helper'

RSpec.describe Api::V1::SustainableDevelopmentGoalsController, type: :controller do
  let(:valid_attributes) do
    file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
    attributes_for(:sustainable_development_goal).merge(icon: file)
  end

  let(:invalid_attributes) do
    attributes_for(:sustainable_development_goal, :invalid)
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
      sustainable_development_goal = create :sustainable_development_goal
      get :show, params: { id: sustainable_development_goal.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SustainableDevelopmentGoal' do
        expect {
          post :create, params: { sustainable_development_goal: valid_attributes }, session: valid_session
        }.to change(SustainableDevelopmentGoal, :count).by(1)
      end

      it 'renders a JSON response with the new sustainable_development_goal' do
        post :create, params: { sustainable_development_goal: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it 'attaches the uploaded file' do
        file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
        expect {
          post :create, params: { sustainable_development_goal: valid_attributes.merge(icon: file) }
        }.to change(ActiveStorage::Attachment, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new sustainable_development_goal' do
        post :create, params: { sustainable_development_goal: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:sustainable_development_goal, name: 'New Sustainable Development Goal')
      end

      it 'updates the requested sustainable_development_goal' do
        sustainable_development_goal = create :sustainable_development_goal
        put :update, params: {
          id: sustainable_development_goal.to_param,
          sustainable_development_goal: new_attributes
        }, session: valid_session

        sustainable_development_goal.reload
        expect(sustainable_development_goal.name).to eq('New Sustainable Development Goal')
      end

      it 'renders a JSON response with the sustainable_development_goal' do
        sustainable_development_goal = create :sustainable_development_goal

        put :update, params: {
          id: sustainable_development_goal.to_param,
          sustainable_development_goal: valid_attributes
        }, session: valid_session

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the sustainable_development_goal' do
        sustainable_development_goal = create :sustainable_development_goal

        put :update, params: {
          id: sustainable_development_goal.to_param,
          sustainable_development_goal: invalid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested sustainable_development_goal' do
      sustainable_development_goal = create :sustainable_development_goal
      expect {
        delete :destroy, params: { id: sustainable_development_goal.to_param }, session: valid_session
      }.to change(SustainableDevelopmentGoal, :count).by(-1)
    end
  end
end
