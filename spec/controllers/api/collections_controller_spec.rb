require 'rails_helper'
include ActionController::RespondWith


RSpec.describe Api::CollectionsController, type: :controller do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }
  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }
  let(:collection) { create :collection, teacher: teacher }
  let(:activity_sequence) { create :activity_sequence }

  let(:valid_attributes) { attributes_for :collection }
  let(:invalid_attributes) { attributes_for :collection, :invalid }

  describe 'GET #index' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'on teacher_id scope' do
        context 'returns http no content' do
          it 'returns no content' do
            get :index, params: { teacher_id: teacher.id }

            expect(response).to have_http_status(:ok)
            expect(response).to be_successful
          end
        end

        context 'returns http success' do
          it 'if valid content' do
            create :collection, teacher: teacher

            get :index, params: { teacher_id: teacher.id }

            expect(response.content_type).to eq('application/json')
            expect(response).to be_successful
          end

          it 'return valid JSON all filters' do
            create :collection, teacher: teacher

            get :index, params: { teacher_id: teacher.id }

            expect(first_body['id']).to be_present
            expect(first_body['name']).to be_present
            expect(first_body['teacher_id']).to be_present
            expect(first_body['number_of_activity_sequences']).to be_present
            # TODO: Remove comment from the line below when classes are implemented
            # expect(first_body['number_of_classes']).to be_present
          end
        end

        context 'returns http unauthorized' do
          it 'if the current user is different from the requested one' do
            another_user = create :user
            another_teacher = create :teacher, user: another_user

            get :index, params: { teacher_id: another_teacher.id }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'on activity sequence scope' do
        context 'returns http no content' do
          it 'returns no content' do
            get :index, params: { activity_sequence_slug: activity_sequence.slug }

            expect(response).to have_http_status(:no_content)
            expect(response).to be_successful
          end
        end

        context 'returns http success' do
          it 'if valid content' do
            create :collection, teacher: teacher
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            get :index, params: { activity_sequence_slug: activity_sequence.slug }

            expect(response.content_type).to eq('application/json')
            expect(response).to be_successful
          end

          it 'return valid JSON all filters' do
            create :collection, teacher: teacher
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            get :index, params: { activity_sequence_slug: activity_sequence.slug }

            expect(first_body['id']).to be_present
            expect(first_body['name']).to be_present
            expect(first_body['teacher_id']).to be_present
            expect(first_body['number_of_activity_sequences']).to be_present
            # TODO: Remove comment from the line below when classes are implemented
            # expect(first_body['number_of_classes']).to be_present
          end
        end

        context 'returns http unauthorized' do
          it 'if the current user is different from the requested one' do
            another_user = create :user
            another_teacher = create :teacher, user: another_user

            get :index, params: { teacher_id: another_teacher.id }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    context 'unregistered users' do
      it 'returns http unauthorized' do
        get :index, params: { teacher_id: teacher.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'returns a success response' do
        it 'if exists content data' do
          collection = create :collection, teacher: teacher
          get :show, params: { teacher_id: teacher.id, id: collection.to_param }

          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end

        it 'return valid JSON all filters' do
          collection = create :collection, teacher: teacher
          get :show, params: { teacher_id: teacher.id, id: collection.to_param }

          expect(response_body['id']).to be_present
          expect(response_body['name']).to be_present
          expect(response_body['teacher_id']).to be_present
          expect(response_body['number_of_activity_sequences']).to be_present
          # TODO: Remove comment from the line below when classes are implemented
          # expect(response_body['number_of_classes']).to be_present
        end
      end

      context 'returns a http no content response' do
        it 'if not exists collection' do
          get :show, params: { teacher_id: teacher.id, id: 9_999_999_999 }

          expect(response).to be_successful
          expect(response).to have_http_status(:no_content)
        end

        it 'if not exists teacher' do
          get :show, params: { teacher_id: 999_999_999, id: 9_999_999_999 }

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'returns http unauthorized' do
        it 'if the current user is different from the requested one' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user

          get :show, params: { teacher_id: another_teacher.id, id: collection.to_param }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'with valid params' do
        it 'creates a new Collection' do
          expect {
            post :create, params: { teacher_id: teacher.id, collection: valid_attributes }
          }.to change(Collection, :count).by(1)
        end

        it 'renders a JSON response with the new Collection' do
          post :create, params: { teacher_id: teacher.id, collection: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the new Collection' do
          post :create, params: { teacher_id: teacher.id, collection: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'returns http unauthorized' do
        it 'if the current user is different from the requested one' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user

          post :create, params: { teacher_id: another_teacher.id, collection: valid_attributes }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'with valid params' do
        let(:new_attributes) do
          attributes_for(:collection, name: 'New collection')
        end

        it 'updates the requested collection' do
          collection = create :collection, teacher: teacher
          put :update, params: { teacher_id: teacher.id, id: collection.to_param, collection: new_attributes }
          collection.reload

          expect(collection.name).to eq('New collection')
        end

        it 'renders a JSON response with the collection' do
          collection = create :collection, teacher: teacher

          put :update, params: { teacher_id: teacher.id, id: collection.to_param, collection: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the collection' do
          collection = create :collection, teacher: teacher

          put :update, params: { teacher_id: teacher.id, id: collection.to_param, collection: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'returns http unauthorized' do
        it 'if the current user is different from the requested one' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user

          put :update, params: { teacher_id: another_teacher.id, id: collection.to_param, collection: valid_attributes }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      it 'destroys the requested collection' do
        collection = create :collection, teacher: teacher

        expect {
          delete :destroy, params: { teacher_id: teacher.id, id: collection.to_param }
        }.to change(Collection, :count).by(-1)
      end

      it 'renders a http success response' do
        collection = create :collection, teacher: teacher

        delete :destroy, params: { teacher_id: teacher.id, id: collection.to_param }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http unauthorized' do
      it 'if the current user is different from the requested one' do
        another_user = create :user
        another_teacher = create :teacher, user: another_user

        delete :destroy, params: { teacher_id: another_teacher.id, id: collection.to_param }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
