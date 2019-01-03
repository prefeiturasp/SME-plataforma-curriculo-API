require 'rails_helper'

RSpec.describe Api::ActivitySequencesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }

  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }
  let(:collection) { create :collection, teacher: teacher }
  let(:activity_sequence) { create :activity_sequence }
  let(:collection_activity_sequence) { create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence }

  let(:valid_attributes_in_collection) { attributes_for :collection_activity_sequence, activity_sequence_id: activity_sequence.id }
  let(:invalid_attributes_in_collection) { attributes_for :collection_activity_sequence, activity_sequence_id: nil }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #index' do
    context 'without collection' do
      context 'returns http no content' do
        it 'returns no content' do
          get :index

          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end

        it 'returns no content with activity sequence in draft' do
          create :activity_sequence, status: :draft

          get :index

          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'returns http success' do
        before do
          @activity_sequence = create :activity_sequence, :reindex, title: "ZZZZZ", status: :published
        end

        it 'returns http success' do
          get :index

          expect(response.content_type).to eq('application/json')
          expect(response).to be_successful
        end

        it 'orders by ascending title' do
          activity_sequence_one = create :activity_sequence, :reindex, title: 'BBBB', status: :published
          activity_sequence_two = create :activity_sequence, :reindex, title: "AAAA", status: :published
          ActivitySequence.searchkick_index.refresh

          get :index, params: { order_by: 'title', sort: 'asc' }

          response_titles = response_body.map {|a_sequence| a_sequence["title"]}

          expect(response_titles).to eq([activity_sequence_two.title, activity_sequence_one.title, @activity_sequence.title])
        end

        it 'return valid JSON all filters' do
          get :index

          expect(first_body['id']).to be_present
          expect(first_body['slug']).to be_present
          expect(first_body['title']).to be_present
          expect(first_body['main_curricular_component']).to be_present
          expect(first_body['estimated_time']).to be_present
          expect(first_body['status']).to be_present
          expect(first_body['keywords']).to be_present
          expect(first_body['number_of_activities']).to be_present
          expect(first_body['image_attributes']).to be_present
          expect(first_body['year']).to be_present
          expect(first_body['knowledge_matrices']).to be_present
          expect(first_body['learning_objectives']).to be_present
          expect(first_body['sustainable_development_goals']).to be_present
        end

        it 'return valid image attributes JSON' do
          get :index

          expect(first_body['image_attributes']).to be_present
          expect(first_body['image_attributes']['default_url']).to be_present
          expect(first_body['image_attributes']['default_size']).to be_present
        end

        it 'return valid knowledge matrices JSON' do
          get :index

          expect(first_body['knowledge_matrices']).to be_present
          expect(first_body['knowledge_matrices'][0]['sequence']).to be_present
          expect(first_body['knowledge_matrices'][0]['title']).to be_present
        end

        it 'return valid learning objectives JSON' do
          get :index

          expect(first_body['learning_objectives']).to be_present
          expect(first_body['learning_objectives'][0]['code']).to be_present
          expect(first_body['learning_objectives'][0]['color']).to be_present
        end

        it 'return valid sustainable development goals JSON' do
          get :index

          expect(first_body['sustainable_development_goals']).to be_present
          expect(first_body['sustainable_development_goals'][0]['name']).to be_present
          expect(first_body['sustainable_development_goals'][0]['icon_url']).to be_present
        end

        it 'return valid main_curricular_component' do
          get :index

          expect(first_body['main_curricular_component']['name']).to be_present
          expect(first_body['main_curricular_component']['color']).to be_present
        end
      end
    end

    context 'with collection' do
      context 'logged in users' do
        before do
          authenticate_user user
        end

        context 'returns http no content' do
          it 'returns no content' do
            get :index, params: { teacher_id: teacher.id, collection_id: collection.id }

            expect(response).to have_http_status(:ok)
            expect(response).to be_successful
          end
        end

        context 'returns http success' do
          it 'if valid content' do
            create :collection, teacher: teacher

            get :index, params: { teacher_id: teacher.id, collection_id: collection.id }

            expect(response.content_type).to eq('application/json')
            expect(response).to be_successful
          end

          it 'return valid JSON all filters' do
            activity_sequence = create :activity_sequence, status: :published
            collection = create :collection, teacher: teacher
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            get :index, params: { teacher_id: teacher.id, collection_id: collection.id }

            expect(first_body['id']).to be_present
            expect(first_body['sequence']).to be_present
          end
        end

        context 'returns http unauthorized' do
          it 'if the collection is from another user' do
            activity_sequence = create :activity_sequence, status: :published
            collection = create :collection, teacher: teacher
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            another_user = create :user
            another_teacher = create :teacher, user: another_user
            another_collection = create :collection, teacher: another_teacher

            get :index, params: { teacher_id: teacher.id, collection_id: another_collection.id }

            expect(response).to have_http_status(:ok)
          end

          it 'if the current user is different from the requested one' do
            activity_sequence = create :activity_sequence, status: :published
            collection = create :collection, teacher: teacher
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            another_user = create :user
            another_teacher = create :teacher, user: another_user
            another_collection = create :collection, teacher: another_teacher

            get :index, params: { teacher_id: another_teacher.id, collection_id: collection.id }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'unregistered users' do
        it 'returns http unauthorized' do
          get :index, params: { teacher_id: teacher.id, collection_id: collection.id }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:activity) { create :activity }
    let(:sustainable_development_goal) { create :sustainable_development_goal }
    let(:axis) { create :axis }
    let(:activity_sequence) do
      create :activity_sequence,
             activity_ids: [activity.id]
    end

    context 'without collection' do
      context 'returns http no content' do
        it 'if slug not exists no content' do
          get :show, params: { slug: 'invalid-slug' }

          expect(response).to be_successful
          expect(response).to have_http_status(:no_content)
        end
      end
      context 'returns http success' do
        it 'returns http success' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response.content_type).to eq('application/json')
          expect(response).to be_successful
        end

        it 'return valid JSON all filters' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['slug']).to be_present
          expect(response_body['title']).to be_present
          expect(response_body['year']).to be_present
          expect(response_body['main_curricular_component']).to be_present
          expect(response_body['estimated_time']).to be_present
          expect(response_body['status']).to be_present
          expect(response_body['keywords']).to be_present
          expect(response_body['books']).to be_present
          expect(response_body['image_attributes']).to be_present
          expect(response_body['presentation_text']).to be_present
          expect(response_body['curricular_components']).to be_present
          expect(response_body['knowledge_matrices']).to be_present
          expect(response_body['learning_objectives']).to be_present
          expect(response_body['sustainable_development_goals']).to be_present
          expect(response_body['activities']).to be_present
        end

        it 'return valid knowledge matrices JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['knowledge_matrices']).to be_present
          expect(response_body['knowledge_matrices'][0]['sequence']).to be_present
          expect(response_body['knowledge_matrices'][0]['title']).to be_present
        end

        it 'return valid learning objectives JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['learning_objectives']).to be_present
          expect(response_body['learning_objectives'][0]['code']).to be_present
          expect(response_body['learning_objectives'][0]['description']).to be_present
          expect(response_body['learning_objectives'][0]['color']).to be_present
        end

        it 'return valid curricular components JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['curricular_components']).to be_present
          expect(response_body['curricular_components'][0]['name']).to be_present
        end

        it 'return valid sustainable development goals JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['sustainable_development_goals']).to be_present
          expect(response_body['sustainable_development_goals'][0]['id']).to be_present
          expect(response_body['sustainable_development_goals'][0]['name']).to be_present
          expect(response_body['sustainable_development_goals'][0]['icon_url']).to be_present
          expect(response_body['sustainable_development_goals'][0]['sub_icon_url']).to be_present
        end

        it 'return valid main curricular component JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['main_curricular_component']).to be_present
          expect(response_body['main_curricular_component']['name']).to be_present
          expect(response_body['main_curricular_component']['color']).to be_present
        end

        it 'return valid activities JSON' do
          get :show, params: { slug: activity_sequence.slug }

          expect(response_body['activities']).to be_present
          expect(response_body['activities'][0]['image_attributes']).to be_present
          expect(response_body['activities'][0]['title']).to be_present
          expect(response_body['activities'][0]['estimated_time']).to be_present
        end
      end
    end
    context 'with collection' do
      context 'logged in users' do
        before do
          authenticate_user user
        end

        context 'returns http success' do
          it 'if valid activity sequence in collection' do
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence
            get :show, params: { teacher_id: teacher.id, collection_id: collection.id, id: activity_sequence.id }

            expect(response.content_type).to eq('application/json')
            expect(response).to be_successful
          end

          it 'return sequence on JSON' do
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence
            get :show, params: { teacher_id: teacher.id, collection_id: collection.id, id: activity_sequence.id }

            expect(response_body['sequence']).to be_present
          end
        end

        context 'returns http no content' do
          it 'if not exists teacher' do
            get :show, params: { teacher_id: 999_999_999, collection_id: 999_999_999, id: 999_999_999 }

            expect(response).to have_http_status(:no_content)
          end

          it 'if not exists collection' do
            get :show, params: { teacher_id: teacher.id, collection_id: 9_999_999_999, id: 9_999_999_999 }

            expect(response).to be_successful
            expect(response).to have_http_status(:no_content)
          end

          it 'if request another collection' do
            another_collection = create :collection

            get :show, params: { teacher_id: teacher.id, collection_id: another_collection.id, id: activity_sequence.id }

            expect(response).to be_successful
            expect(response).to have_http_status(:no_content)
          end

          it 'if activity sequence not exists in collection' do
            another_activity_sequence = create :activity_sequence
            # set activity sequence in collection
            create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            # get another activity sequence
            get :show, params: { teacher_id: teacher.id, collection_id: collection.id, id: another_activity_sequence.id }

            expect(response).to be_successful
            expect(response).to have_http_status(:no_content)
          end
        end

        context 'returns http unauthorized' do
          it 'if the current user is different from the requested one' do
            another_user = create :user
            another_teacher = create :teacher, user: another_user

            get :show, params: { teacher_id: another_teacher.id, collection_id: collection.id, id: activity_sequence.id }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'unregistered users' do
        it 'returns http unauthorized' do
          get :show, params: { teacher_id: teacher.id, collection_id: collection.id, id: activity_sequence.id }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'assign activity sequence on collections' do
      context 'logged in users' do
        before do
          authenticate_user user
        end

        context 'with valid params' do
          it 'assigns an activity sequence in a collection' do
            expect {
              post :create, params: { teacher_id: teacher.id, collection_id: collection.id, collection_activity_sequence: valid_attributes_in_collection }
            }.to change(CollectionActivitySequence, :count).by(1)
          end

          it 'renders a JSON response if assigns an activity sequence in a collection' do
            post :create, params: { teacher_id: teacher.id, collection_id: collection.id, collection_activity_sequence: valid_attributes_in_collection }

            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
          end
        end

        context 'with invalid params' do
          it 'renders a JSON response with errors for the new Collection' do
            post :create, params: { teacher_id: teacher.id, collection_id: collection.id, collection_activity_sequence: invalid_attributes_in_collection }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
        end

        context 'returns http unauthorized' do
          it 'if the current user is different from the requested one' do
            another_user = create :user
            another_teacher = create :teacher, user: another_user

            post :create, params: { teacher_id: another_teacher.id, collection_id: collection.id, collection_activity_sequence: valid_attributes_in_collection }

            expect(response).to have_http_status(:unauthorized)
          end

          it 'if request another collection' do
            another_collection = create :collection

            post :create, params: { teacher_id: teacher.id, collection_id: another_collection.id, collection_activity_sequence: valid_attributes_in_collection }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a collection' do
      context 'logged in users' do
        before do
          authenticate_user user
        end

        it 'dissociates the activity sequence of the collection' do
          collection_activity_sequence = create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

          expect {
            delete :destroy, params: { teacher_id: teacher.id, collection_id: collection.id, id: activity_sequence.id }
          }.to change(CollectionActivitySequence, :count).by(-1)
        end

        it 'renders a http success response' do
          collection_activity_sequence = create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

          delete :destroy, params: { teacher_id: teacher.id, collection_id: collection.id, id: activity_sequence.id }

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'returns http unauthorized' do
        it 'if the collection is the another teacher' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user
          another_collection = create :collection, teacher: another_teacher

          delete :destroy, params: { teacher_id: teacher.id, collection_id: another_collection.id, id: activity_sequence.id }

          expect(response).to have_http_status(:unauthorized)
        end

        it 'if the current user is different from the teacher requested one' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user

          delete :destroy, params: { teacher_id: another_teacher.id, collection_id: collection.id, id: activity_sequence.id }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with a collection' do
      context 'logged in users' do
        before do
          authenticate_user user
        end
        let(:new_sequence_number) { 987654 }
        let(:new_attributes_in_collection) do
          attributes_for :collection_activity_sequence, activity_sequence_id: activity_sequence.id, sequence: new_sequence_number
        end

        context 'with valid params' do
          it 'updates the requested collection_activity_sequence' do
            collection_activity_sequence = create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            put :update, params: { teacher_id: teacher.id,
                                   collection_id: collection.id,
                                   id: activity_sequence.id,
                                   collection_activity_sequence: new_attributes_in_collection }
            collection_activity_sequence.reload

            expected_sequence = 1 # because reorder

            expect(collection_activity_sequence.sequence).to eq(expected_sequence)
          end

          it 'renders a JSON response with the collection' do
            collection_activity_sequence = create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            put :update, params: { teacher_id: teacher.id,
                                   collection_id: collection.id,
                                   id: activity_sequence.id,
                                   collection_activity_sequence: new_attributes_in_collection }

            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq('application/json')
          end
        end

        context 'with invalid params' do
          let(:invalid_new_attributes_in_collection) do
            attributes_for :collection_activity_sequence, activity_sequence_id: activity_sequence.id, sequence: 'asdf'
          end

          it 'renders a JSON response with errors for the collection' do
            collection_activity_sequence = create :collection_activity_sequence, collection: collection, activity_sequence: activity_sequence

            put :update, params: { teacher_id: teacher.id,
                                   collection_id: collection.id,
                                   id: activity_sequence.id,
                                   collection_activity_sequence: invalid_new_attributes_in_collection }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
        end

        context 'return http no content' do
          it 'if the collection is the another teacher' do
            another_user = create :user
            another_teacher = create :teacher, user: another_user
            another_collection = create :collection, teacher: another_teacher

            put :update, params: { teacher_id: teacher.id,
                                   collection_id: another_collection.id,
                                   id: activity_sequence.id,
                                   collection_activity_sequence: new_attributes_in_collection }

            expect(response).to have_http_status(:no_content)
          end
        end

        context 'returns http unauthorized' do
          it 'if the current user is different from the teacher requested one' do
            another_user = create :user, email: 'asdf@asdf.com'
            another_teacher = create :teacher, user: another_user

            put :update, params: { teacher_id: another_teacher.id,
                                   collection_id: collection.id,
                                   id: activity_sequence.id,
                                   collection_activity_sequence: new_attributes_in_collection }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
