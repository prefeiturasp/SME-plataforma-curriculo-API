require 'rails_helper'

RSpec.describe Api::ActivitySequenceRatingsController, type: :controller do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }
  let(:rating) { create :rating }
  let(:activity_sequence) { create :activity_sequence }
  let(:activity_sequence_performed) do
    create :activity_sequence_performed, teacher: teacher, activity_sequence: activity_sequence
  end

  let(:valid_attributes) do
    {
      teacher_id: activity_sequence_performed.teacher.id,
      rating_id: rating.id,
      score: Faker::Number.between(0, 5)
    }
  end

  let(:invalid_attributes) do
    {
      teacher_id: activity_sequence_performed.teacher.id,
      score: Faker::Number.between(6, 10)
    }
  end

  describe 'POST #create' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'with valid params' do
        it 'creates a new Activity Sequence Rating' do
          expect {
            post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                    activity_sequence_rating: valid_attributes }
          }.to change(ActivitySequenceRating, :count).by(1)
        end

        it 'renders a JSON response with the new Activity Sequence Rating' do
          post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                  activity_sequence_rating: valid_attributes }

          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the new Activity Sequence Rating' do
          post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                  activity_sequence_rating: invalid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'returns http unauthorized' do
        it 'if the current user is different from the requested one' do
          another_user = create :user
          another_teacher = create :teacher, user: another_user
          valid_attributes[:teacher_id] = another_teacher.id

          post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                  activity_sequence_rating: valid_attributes }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'returns http unprocessable entity' do
        it 'if activity sequence not performed' do
          another_activity_sequence = create :activity_sequence
          post :create, params: { activity_sequence_slug: another_activity_sequence.slug,
                                  activity_sequence_rating: valid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end

        it 'if activity sequence already performed per rating' do
          create :activity_sequence_rating, activity_sequence_performed: activity_sequence_performed, rating: rating

          post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                  activity_sequence_rating: valid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'return http not content' do
        it 'if activity sequence not exists' do
          post :create, params: { activity_sequence_slug: 'slug-nonexistent',
                                  activity_sequence_rating: valid_attributes }

          expect(response).to have_http_status(:no_content)
        end

        it 'without activity sequence rating params' do
          post :create, params: { activity_sequence_slug: activity_sequence.slug }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
