require 'rails_helper'

RSpec.describe Api::V1::ActivitySequencesController, type: :controller do
  let(:valid_attributes) do
    file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
    attributes_for(
      :activity_sequence,
      main_curricular_component_id: create(:curricular_component).id
    ).merge(image: file)
  end

  let(:invalid_attributes) do
    attributes_for :activity_sequence, :invalid
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
      activity_sequence = create :activity_sequence
      get :show, params: { id: activity_sequence.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ActivitySequence' do
        expect {
          post :create, params: { activity_sequence: valid_attributes }, session: valid_session
        }.to change(ActivitySequence, :count).by(1)
        activity_sequence = ActivitySequence.last

        expect(activity_sequence.image.attached?).to be true
      end

      it 'renders a JSON response with the new activity_sequence' do
        post :create, params: { activity_sequence: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new activity_sequence' do
        post :create, params: { activity_sequence: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'new.png'), 'image/png')
        attributes_for(
          :activity_sequence,
          title: 'New Title',
          main_curricular_component_id: create(:curricular_component).id,
          curricular_components: [create(:curricular_component)],
          knowledge_matrices: [create(:knowledge_matrix)],
          learning_objectives: [create(:learning_objective)],
          sustainable_development_goals: [create(:sustainable_development_goal)]
        ).merge(image: file)
      end

      it 'updates the requested activity_sequence' do
        activity_sequence = create :activity_sequence
        expect(activity_sequence.image.filename).to eq('ruby.png')
        put :update, params: {
          id: activity_sequence.to_param,
          activity_sequence: new_attributes
        }, session: valid_session

        activity_sequence.reload
        expect(activity_sequence.title).to eq('NEW TITLE')
        expect(activity_sequence.image.filename).to eq('new.png')
      end

      it 'renders a JSON response with the activity_sequence' do
        activity_sequence = create :activity_sequence

        put :update, params: {
          id: activity_sequence.to_param,
          activity_sequence: valid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the activity_sequence' do
        activity_sequence = create :activity_sequence

        put :update, params: {
          id: activity_sequence.to_param,
          activity_sequence: invalid_attributes
        }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested activity_sequence' do
      activity_sequence = create :activity_sequence
      expect {
        delete :destroy, params: {
          id: activity_sequence.to_param
        }, session: valid_session
      }.to change(ActivitySequence, :count).by(-1)
    end
  end
end
