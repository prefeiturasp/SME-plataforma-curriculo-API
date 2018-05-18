require 'rails_helper'

RSpec.describe Api::V1::CurricularComponentsController, type: :controller do
  let(:valid_attributes) do
    attributes_for(:curricular_component)
  end

  let(:invalid_attributes) do
    attributes_for(:curricular_component, :invalid_name)
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
      curricular_component = create :curricular_component
      get :show, params: { id: curricular_component.to_param }, session: valid_session

      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new CurricularComponent' do
        expect {
          post :create, params: { curricular_component: valid_attributes }, session: valid_session
        }.to change(CurricularComponent, :count).by(1)
      end

      it 'renders a JSON response with the new curricular_component' do
        post :create, params: { curricular_component: valid_attributes }, session: valid_session

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new curricular_component' do
        post :create, params: { curricular_component: invalid_attributes }, session: valid_session

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:curricular_component, name: 'New CurricularComponent Test')
      end

      it 'updates the requested curricular_component' do
        curricular_component = create :curricular_component
        put :update, params: {
          id: curricular_component.to_param,
          curricular_component: new_attributes
        }, session: valid_session
        curricular_component.reload

        expect(curricular_component.name).to eq('New CurricularComponent Test')
      end

      it 'renders a JSON response with the curricular_component' do
        curricular_component = create :curricular_component

        put :update, params: {
          id: curricular_component.to_param,
          curricular_component: valid_attributes
        }, session: valid_session

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the curricular_component' do
        curricular_component = create :curricular_component

        put :update, params: {
          id: curricular_component.to_param,
          curricular_component: invalid_attributes
        }, session: valid_session

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested curricular_component' do
      curricular_component = create :curricular_component

      expect {
        delete :destroy, params: { id: curricular_component.to_param }, session: valid_session
      }.to change(CurricularComponent, :count).by(-1)
    end
  end
end
