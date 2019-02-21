require 'rails_helper'

RSpec.describe Admin::LearningObjectivesController, type: :controller do
  describe 'GET #change_axes' do
    before :each do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end
    let!(:curricular_component) { create :curricular_component }
    let!(:axis) { create :axis, curricular_component: curricular_component }

    context 'logged users' do
      context 'if is admin' do
        it 'returns a success response' do
          user = create :user, admin: true
          sign_in user

          get :change_axes, params: { curricular_component_id: curricular_component.id }

          expect(response).to be_successful
        end

        it 'returns axis data' do
          user = create :user, admin: true
          sign_in user

          get :change_axes, params: { curricular_component_id: curricular_component.id }

          expected_response = "#{[[axis.id,axis.description]]}".gsub(', ',',')
          expect(response.body).to eq(expected_response)
        end
      end
      context 'if not is admin' do
        it 'returns no content' do
          user = create :user, admin: false
          sign_in user

          get :change_axes, params: { curricular_component_id: curricular_component.id }

          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'unlogged users' do
      it 'returns unauthorized' do
        get :change_axes, params: { curricular_component_id: curricular_component.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
