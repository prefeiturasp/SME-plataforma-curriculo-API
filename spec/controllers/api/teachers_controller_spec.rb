require 'rails_helper'
include ActionController::RespondWith

RSpec.describe Api::TeachersController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:valid_attributes) do
    file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
    attributes_for(:teacher).merge(avatar: file)
  end
  let(:invalid_attributes) do
    attributes_for :teacher, :invalid
  end

  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }

  describe 'GET #show' do
    context "user not signed in" do
      it 'returns unauthorized status' do
        get :show, params: { id: teacher.id }     
      
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "user signed in" do
      it 'returns a success response' do   
        authenticate_user user

        get :show, params: { id: teacher.id }     
  
        expect(response).to be_successful
      end

      it 'return unauthorized status if the resource is from another user' do
        another_user = create :user
        another_teacher = create :teacher, user: another_user

        authenticate_user user

        get :show, params: { id: another_teacher.id }

        expect(response).to have_http_status(:unauthorized)
      end

      it 'return valid JSON all filters' do
        authenticate_user user

        get :show, params: { id: teacher.id }  

        expect(response_body['id']).to be_present
        expect(response_body['name']).to be_present
        expect(response_body['nickname']).to be_present
        expect(response_body['avatar_attributes']).to be_present
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Teacher' do
        authenticate_user user

        expect {
          post :create, params: { teacher: valid_attributes }
        }.to change(Teacher, :count).by(1)
        teacher = Teacher.last

        expect(teacher.avatar.attached?).to be true
      end

      it 'renders a JSON response with the new teacher' do
        authenticate_user user

        post :create, params: { teacher: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new teacher' do
        authenticate_user user

        post :create, params: { teacher: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_nickname) { 'New Nickname' }
      let(:new_attributes) do
        file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'new.png'), 'image/png')
        attributes_for(
          :teacher,
          nickname: new_nickname
        ).merge(avatar: file)
      end

      it 'updates the requested teacher' do
        authenticate_user user

        expect(teacher.avatar.filename).to eq('ruby.png')
        put :update, params: {
          id: teacher.to_param,
          teacher: new_attributes
        }

        teacher.reload
        expect(teacher.nickname).to eq(new_nickname)
        expect(teacher.avatar.filename).to eq('new.png')
      end

      it 'renders a JSON response with the teacher' do
        authenticate_user user

        put :update, params: {
          id: teacher.to_param,
          teacher: valid_attributes
        }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the teacher' do
        authenticate_user user

        put :update, params: {
          id: teacher.to_param,
          teacher: invalid_attributes
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with updates data another user' do
      let(:new_attributes) do
        file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'new.png'), 'image/png')
        attributes_for(
          :teacher,
          nickname: 'new_nickname'
        ).merge(avatar: file)
      end

      it 'renders unauthorized' do
        authenticate_user user
        another_user = create :user
        another_teacher = create :teacher, user: another_user

        put :update, params: {
          id: another_teacher.id,
          teacher: new_attributes
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #avatar' do

    let(:valid_avatar_attribute) do
      file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
      { avatar: file }
    end

    context 'with valid avatar params' do
      it 'updates a new avatar' do
        authenticate_user user

        expect {
          post :avatar, params: { teacher_id: teacher.to_param, teacher: valid_avatar_attribute }
        }.to change(Teacher, :count).by(1)
        teacher = Teacher.last

        expect(teacher.avatar.attached?).to be true
      end

      it 'renders a :ok with the new avatar' do
        authenticate_user user

        post :avatar, params: { teacher_id: teacher.to_param, teacher: valid_avatar_attribute }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid avatar params' do
      it 'renders a JSON response with errors for the new teacher' do
        authenticate_user user

        post :avatar, params: { teacher_id: teacher.to_param, teacher: { avatar: 'invalid avatar' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #avatar_purge' do
    context 'render http status no content' do
      it 'if avatar exists' do
        new_user = create :user
        new_teacher = create :teacher, user: new_user
        authenticate_user new_user

        delete :avatar_purge, params: { teacher_id: new_teacher.to_param }

        expect(response).to have_http_status(:no_content)
      end

      it 'if avatar NOT exists' do
        new_user = create :user
        new_teacher = create :teacher, user: new_user, avatar: nil
        authenticate_user new_user

        delete :avatar_purge, params: { teacher_id: new_teacher.to_param }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'return unauthorized status' do
      it "user not signed in" do
        delete :avatar_purge, params: { teacher_id: 9999999999 }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'renders unprocessable_entity' do
      it 'if teacher not exists' do
        new_user = create :user
        authenticate_user new_user

        delete :avatar_purge, params: { teacher_id: 9999999999 }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #all_collections' do
    it 'returns a success response' do   
      create :collection, teacher: teacher

      get :all_collections, params: { teacher_id: teacher.id }

      expect(response).to be_successful
    end

    it 'return valid JSON' do
      collection = create :collection, teacher: teacher
      create :collection_activity_sequence, collection: collection

      get :all_collections, params: { teacher_id: teacher.id }

      expect(response_body[0]['id']).to be_present
      expect(response_body[0]['name']).to be_present
      expect(response_body[0]['activity_sequences']).to be_present
    end

    it 'return valid activity sequences on JSON' do
      collection = create :collection, teacher: teacher
      create :collection_activity_sequence, collection: collection

      get :all_collections, params: { teacher_id: teacher.id }
      first_activity_sequence = response_body[0]['activity_sequences'].first

      expected_keys = %W(id slug title)
      expect(first_activity_sequence.keys).to contain_exactly(*expected_keys)
    end

  end
end
