require 'rails_helper'

RSpec.describe Api::ActivitySequencePerformedsController, type: :controller do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }
  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }
  let(:activity_sequence_performed) { create :activity_sequence_performed, teacher: teacher }

  let(:valid_attributes) { attributes_for :activity_sequence_performed }
  let(:invalid_attributes) { attributes_for :activity_sequence_performed, teacher: nil }

  describe 'GET #index' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'returns http no content' do
        it 'returns no content' do
          get :index, params: { teacher_id: teacher.id }

          expect(response).to have_http_status(:ok)
          expect(response).to be_successful
        end
      end

      context 'returns http success' do
        it 'if valid content' do
          create :activity_sequence_performed, teacher: teacher

          get :index, params: { teacher_id: teacher.id }

          expect(response.content_type).to eq('application/json')
          expect(response).to be_successful
        end

        it 'return valid JSON all filters' do
          create :activity_sequence_performed, teacher: teacher, evaluated: true

          get :index, params: { teacher_id: teacher.id }

          expect(first_body['activity_sequence_id']).to be_present
          expect(first_body['teacher_id']).to be_present
          expect(first_body['evaluated']).to be_present
          expect(first_body['activity_sequence']).to be_present
        end

        it 'return valid activity sequence JSON' do
          create :activity_sequence_performed, teacher: teacher, evaluated: true

          get :index, params: { teacher_id: teacher.id }

          expect(first_body['activity_sequence']).to be_present
          expect(first_body['activity_sequence']['id']).to be_present
          expect(first_body['activity_sequence']['slug']).to be_present
          expect(first_body['activity_sequence']['title']).to be_present
          expect(first_body['activity_sequence']['main_curricular_component']).to be_present
          expect(first_body['activity_sequence']['image_attributes']).to be_present
        end

        it 'order by created at' do
          activity_sequence_performed_first = create :activity_sequence_performed, teacher: teacher, evaluated: true
          activity_sequence_performed_second = create :activity_sequence_performed, teacher: teacher, evaluated: true

          get :index, params: { teacher_id: teacher.id }

          expect(first_body['activity_sequence_id']).to eq(activity_sequence_performed_first.activity_sequence_id)
          expect(response_body[1]['activity_sequence_id']).to eq(activity_sequence_performed_second.activity_sequence_id)
          expect(first_body['teacher_id']).to eq(activity_sequence_performed_first.teacher_id)
          expect(response_body[1]['teacher_id']).to eq(activity_sequence_performed_second.teacher_id)
        end
      end

      context 'filter by evaluated attribute' do
        let!(:activity_sequence_performed_evaluated) { create :activity_sequence_performed, teacher: teacher, evaluated: true }
        let!(:activity_sequence_performed_not_evaluated) { create :activity_sequence_performed, teacher: teacher, evaluated: false }

        it 'list performeds which were evaluated' do
          get :index, params: { teacher_id: teacher.id, evaluated: 'true' }

          expect(first_body['activity_sequence']['slug']).to eq(activity_sequence_performed_evaluated.activity_sequence.slug)
        end

        it 'list performeds which were not evaluated' do
          get :index, params: { teacher_id: teacher.id, evaluated: 'false' }

          expect(first_body['activity_sequence']['slug']).to eq(activity_sequence_performed_not_evaluated.activity_sequence.slug)
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

    context 'unregistered users' do
      it 'returns http unauthorized' do
        get :index, params: { teacher_id: teacher.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show_ratings' do
    it 'show ratings specific activity sequence' do
      activity_sequence = create :activity_sequence
      activity_sequence_performed = create :activity_sequence_performed,
                                           activity_sequence: activity_sequence,
                                           teacher: teacher,
                                           evaluated: true
      create :activity_sequence_rating,
             activity_sequence_performed: activity_sequence_performed

      get :index, params: { teacher_id: teacher.id, activity_sequence_slug: activity_sequence.slug }

      expect(response).to have_http_status(:ok)
    end
  end
end
