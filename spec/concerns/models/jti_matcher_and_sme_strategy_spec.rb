RSpec.shared_examples_for 'jti_matcher_and_sme_strategy_spec' do
  let(:subject) { create(described_class.to_s.underscore.to_sym) }

  describe 'instance methods' do
    let(:claims) do
      {
        "username": subject.username,
        "jti": subject.jti,
        "exp": (Time.now + 150).to_i,
        "iss": ENV['SME_JWT_ISSUER'],
        "aud": ENV['SME_JWT_AUDIENCE']
      }
    end

    let(:invalid_claims) do
      {
        "username": subject.username,
        "jti": subject.jti,
        "exp": (Time.now - 2.minutes).to_i,
        "iss": ENV['SME_JWT_ISSUER'],
        "aud": ENV['SME_JWT_AUDIENCE']
      }
    end

    let(:valid_sme_token) { JWT.encode(claims, nil, 'none') }
    let(:invalid_sme_token) { JWT.encode(invalid_claims, nil, 'none') }

    let(:response_body) do
      {
        "token": valid_sme_token,
        "refreshToken": '123456'
      }
    end

    context 'jwt_payload' do
      it 'return payload with username and jti' do
        payload_expected = { 'jti' => subject.jti, 'username' => subject.username }

        expect(subject.jwt_payload).to eq(payload_expected)
      end
    end

    context 'valid_sme_token?' do
      it 'return true if exp is valid' do
        subject = create(described_class.to_s.underscore.to_sym, sme_token: valid_sme_token)

        expect(subject.valid_sme_token?).to be true
      end

      it 'return false if exp is invalid' do
        subject = create(described_class.to_s.underscore.to_sym, sme_token: invalid_sme_token)

        expect(subject.valid_sme_token?).to be false
      end
    end

    context 'invalid_payload?' do
      context 'return true' do
        it 'if jti is different' do
          payload = { 'jti' => 'invalid', 'username' => subject.username }

          expect(subject.invalid_payload?(payload)).to eq(true)
        end

        it 'if username is different' do
          payload = { 'jti' => subject.jti, 'username' => 'invalid' }

          expect(subject.invalid_payload?(payload)).to eq(true)
        end
      end

      context 'return false' do
        it 'if jti is eaquals' do
          payload = { 'jti' => subject.jti, 'username' => subject.username }

          expect(subject.invalid_payload?(payload)).to eq(false)
        end
      end
    end

    context 'revoke_jwt!' do
      it 'change jti column' do
        previous_jti = subject.jti
        subject.revoke_jwt!
        subject.reload

        expect(subject.jti).to_not eq(previous_jti)
      end
    end

    context 'invalid_refresh_sme_token?' do
      context 'return true' do
        it 'if token is invalid and not refresh in sme' do
          subject = create(described_class.to_s.underscore.to_sym, sme_token: invalid_sme_token)

          stub_request(:post, "#{ENV['SME_AUTHENTICATION_BASE_URL']}/RefreshLoginJWT")
            .with(
              body: {
                'username' => subject.username,
                'refreshToken' => subject.sme_refresh_token
              },
              headers: request_headers
            ).to_return(status: 401, body: {}.to_json, headers: request_headers)

          expect(subject.invalid_refresh_sme_token?).to be true
        end
      end

      context 'return false' do
        it 'if token is valid ' do
          subject = create(described_class.to_s.underscore.to_sym, sme_token: valid_sme_token)

          expect(subject.invalid_refresh_sme_token?).to be false
        end

        it 'if token is invalid and refresh in sme' do
          subject = create(described_class.to_s.underscore.to_sym, sme_token: invalid_sme_token, sme_refresh_token: '123456')

          stub_request(:post, "#{ENV['SME_AUTHENTICATION_BASE_URL']}/RefreshLoginJWT")
            .with(
              body: {
                'username' => subject.username,
                'refreshToken' => '123456'
              },
              headers: request_headers
            ).to_return(status: 200, body: response_body.to_json, headers: request_headers)

          expect(subject.invalid_refresh_sme_token?).to be false
        end
      end
    end
  end
end
