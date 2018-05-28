require 'rails_helper'

RSpec.describe Api::V1::FileUploadsController, type: :controller do


  describe 'POST #create' do
    context 'with valid params' do
      it 'attaches the uploaded file' do
        activity = create :activity
        file = fixture_file_upload( Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
        expect {
          post :create, params: { activity_id: activity.id, activity: { content_images: file } }
        }.to change(ActiveStorage::Attachment, :count).by(1)
      end

      it 'renders a JSON response with the new file upload' do
        activity = create :activity
        file = fixture_file_upload( Rails.root.join('spec', 'factories', 'images', 'ruby.png'), 'image/png')
        post :create, params: {
          activity_id: activity.id,
          activity: {
            content_images: file
          }
        }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

    end
  end


end
