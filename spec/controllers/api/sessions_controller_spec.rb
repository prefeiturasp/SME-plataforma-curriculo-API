require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:user) { create :user }
  let(:claims) do
    {
      "username": user.username,
      "jti": user.jti,
      "exp": (Time.now + 150).to_i,
      "iss": ENV['SME_JWT_ISSUER'],
      "aud": ENV['SME_JWT_AUDIENCE']
    }
  end
  let(:valid_sme_token) { JWT.encode(claims, nil, 'none') }
  let(:request_headers) do
    {
      'Accept' => 'application/hal+json, application/json;q=0.5',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Connection' => 'Keep-Alive',
      'Content-Type' => 'application/json; charset=utf-8',
      'User-Agent' => 'Flexirest/1.7.5'
    }
  end
  let(:refresh_token) { 'TokjrJZ1JnrhJX8A+meznJg+Gi//1tmK6Ysuc6MA4WQ=' }
  let(:response_sme_body) do
    {
      "token": valid_sme_token,
      "refreshToken": refresh_token
    }
  end

  let(:valid_attributes) { { login: user.username, password: user.password } }
  let(:invalid_attributes) { { login: user.username, password: 'wrong_password' } }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new session' do
        stub_request(:post, "#{ENV['SME_AUTHENTICATION_BASE_URL']}/LoginJWT")
          .with(
            body: {
              'username' => user.username,
              'password' => user.password
            },
            headers: request_headers
          ).to_return(status: 200, body: response_sme_body.to_json, headers: request_headers)

        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'returns http unauthorized' do
      it 'renders a JSON response with errors for the new session' do
        stub_request(:post, "#{ENV['SME_AUTHENTICATION_BASE_URL']}/LoginJWT")
          .with(
            body: {
              'username' => user.username,
              'password' => 'wrong_password'
            },
            headers: request_headers
          ).to_return(status: 401, body: {}.to_json, headers: request_headers)

        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
