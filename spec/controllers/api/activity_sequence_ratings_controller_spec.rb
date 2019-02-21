require 'rails_helper'

RSpec.describe Api::ActivitySequenceRatingsController, type: :controller do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:invalid_score) { Faker::Number.between(6, 10) }
  let(:user) { create :user }
  let(:teacher) { create :teacher, user: user }
  let(:rating) { create :rating }
  let(:another_rating) { create :rating }
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

  let(:valid_attributes_multiple_ratings) do
    {
      teacher_id: activity_sequence_performed.teacher.id,
      ratings: [
        { rating_id: rating.id, score: Faker::Number.between(0, 5) },
        { rating_id: another_rating.id, score: Faker::Number.between(0, 5) }
      ]
    }
  end

  let(:invalid_attributes) do
    {
      teacher_id: activity_sequence_performed.teacher.id,
      score: invalid_score
    }
  end

  let(:invalid_multiple_attributes) do
    {
      teacher_id: activity_sequence_performed.teacher.id,
      ratings: [
        { rating_id: rating.id, score: Faker::Number.between(0, 5) },
        { rating_id: another_rating.id, score: invalid_score }
      ]
    }
  end

  describe 'POST #create' do
    context 'logged in users' do
      before do
        authenticate_user user
      end

      context 'with valid params' do
        context 'with uniq rating' do
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

        context 'with multiple ratings' do
          it 'creates a new Activity Sequence Rating' do
            expect {
              post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                      activity_sequence_rating: valid_attributes_multiple_ratings }
            }.to change(ActivitySequenceRating, :count).by(2)
          end

          it 'renders a JSON response with the new Activity Sequence Rating' do
            post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                    activity_sequence_rating: valid_attributes_multiple_ratings }

            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
          end
        end
      end

      context 'with invalid params' do
        context 'with uniq rating' do
          it 'renders a JSON response with errors for the new Activity Sequence Rating' do
            post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                    activity_sequence_rating: invalid_attributes }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
        end

        context 'with multiple ratings' do
          it 'renders a JSON response with errors for the new Activity Sequence Rating' do
            post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                    activity_sequence_rating: invalid_multiple_attributes }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
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

        context 'with multiple ratings' do
          it 'if any evaluation is missing ' do
            create :rating, enable: true # create new rating
            post :create, params: { activity_sequence_slug: activity_sequence.slug,
                                    activity_sequence_rating: valid_attributes_multiple_ratings }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
          end
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

  describe 'GET #index' do
    let(:response_body) { JSON.parse(response.body) }
    let(:first_body) { response_body[0] }
    let(:another_teacher) { create :teacher }

    let(:activity_sequence) { create :activity_sequence }
    let(:activity_sequence_performed) do
      create :activity_sequence_performed,
            activity_sequence: activity_sequence,
            teacher: teacher,
            evaluated: true
    end

    context 'logged in users' do
      before do
        authenticate_user user
      end

      it 'get ok response on show ratings specific activity sequence' do
        create :activity_sequence_rating,
              activity_sequence_performed: activity_sequence_performed

        get :index, params: { teacher_id: teacher.id, activity_sequence_slug: activity_sequence.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'show JSON ratings specific activity sequence' do
        create :activity_sequence_rating,
              activity_sequence_performed: activity_sequence_performed

        get :index, params: { teacher_id: teacher.id, activity_sequence_slug: activity_sequence.slug }

        expected_keys = %w[rating_id description score]

        expect(first_body.keys).to contain_exactly(*expected_keys)
      end

      it 'render unauthorized if another teacher' do
        create :activity_sequence_rating,
              activity_sequence_performed: activity_sequence_performed

        get :index, params: { teacher_id: another_teacher.id, activity_sequence_slug: activity_sequence.slug }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'unlogged users' do
      it 'get unauthorized' do
        create :activity_sequence_rating,
              activity_sequence_performed: activity_sequence_performed

        get :index, params: { teacher_id: teacher.id, activity_sequence_slug: activity_sequence.slug }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
