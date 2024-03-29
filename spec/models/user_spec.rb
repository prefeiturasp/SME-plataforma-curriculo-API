require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { build :user }

  describe 'Associations' do
    it { should have_one(:teacher) }
  end

  describe 'Validations' do
    describe 'is valid' do
      it 'with valid attributes' do
        expect(subject).to be_valid
      end

      it 'create users different username and equals email' do
        # case_sensitive: false
        subject = create :user, email: '', username: 'test'
        new_subject = build :user, email: '', username: 'test2'

        expect(new_subject).to be_valid
      end
    end

    describe 'is not valid' do
      it 'if username and email is nil' do
        subject = build :user, username: nil, email: nil

        expect(subject).to_not be_valid
      end

      context 'if a username is nil' do
        let(:subject) { build :user, username: nil }

        it 'without a email' do
          subject.email = nil

          expect(subject).to_not be_valid
        end

        it 'if the email already exists' do
          # case_sensitive: false
          subject = create :user, username: nil, email: 'test@test.com'
          new_subject = build :user, username: nil, email: 'TEST@test.com'

          expect(new_subject).to_not be_valid
        end
      end

      context 'if a email is nil' do
        let(:subject) { build :user, email: '' }

        it 'without a username' do
          subject.username = nil

          expect(subject).to_not be_valid
        end

        it 'if the username already exists' do
          # case_sensitive: false
          subject = create :user, email: '', username: 'test'
          new_subject = build :user, email: '', username: 'TEST'

          expect(new_subject).to_not be_valid
        end
      end

      context 'if email and username present' do
        it 'not valid if email already exists' do
          subject = create :user
          new_subject = build :user, email: subject.email

          expect(new_subject).to_not be_valid
        end

        it 'not valid if username already exists' do
          subject = create :user
          new_subject = build :user, username: subject.username

          expect(new_subject).to_not be_valid
        end
      end
    end
  end

  describe 'Getters' do
    context 'login' do
      it 'return username first' do
        expect(subject.login).to eq(subject.username)
      end

      it 'return email if username is nil' do
        subject = create :user, username: nil
        expect(subject.login).to eq(subject.email)
      end

      it 'return username if email is empty' do
        subject = create :user, email: ''
        expect(subject.login).to eq(subject.username)
      end
    end
  end

  describe 'Callbacks' do
    context 'on after_create' do
      context 'assign_teacher' do
        it 'not assign teacher if username is blank' do
          subject = create :user, username: nil

          expect(subject.teacher).to be nil
        end

        it 'not assign teacher if teacher already exists' do
          user = create :user, username: nil
          teacher = create :teacher, user: user

          expect(user.teacher).to eq(teacher)
        end

        it 'assign teacher if not skip crerating teacher' do
          subject_false = create :user, _skip_creating_teacher: false
          subject_nil   = create :user, _skip_creating_teacher: nil

          expect(subject_false.teacher).to_not be nil
          expect(subject_nil.teacher).to_not   be nil
        end
      end
    end
  end

  let(:claims) do
    {
      "username": user.username,
      "jti": user.jti,
      "exp": (Time.now + 150).to_i,
      "iss": ENV['SME_JWT_ISSUER'],
      "aud": ENV['SME_JWT_AUDIENCE']
    }
  end

  let(:invalid_claims) do
    {
      "exp": (Time.now - 150).to_i
    }
  end
  let(:rf_code) { '123456' }
  let(:user) { create :user }
  let(:refresh_token) { 'TokjrJZ1JnrhJX8A+meznJg+Gi//1tmK6Ysuc6MA4WQ=' }
  let(:valid_sme_token) { JWT.encode(claims, nil, 'none') }
  let(:invalid_sme_token) { JWT.encode(invalid_claims, nil, 'none') }
  let(:credentials) { { login: rf_code, senha: user.password } }
  let(:invalid_credentials) { { login: rf_code, senha: 'WRONG' } }
  let(:request_headers) do
    {
      'Accept' => 'application/hal+json, application/json;q=0.5',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Connection' => 'Keep-Alive',
      'Content-Type' => 'application/json; charset=utf-8',
      'User-Agent' => 'Flexirest/1.7.5'
    }
  end

  let(:response_body) do
    {
      "name": user.username,
      "username": user.username,
      "email": user.email,
      "sgpToken": {
        "token": valid_sme_token,
        "refreshToken": refresh_token
      }
    }
  end

  let(:response_body_invalid_token) do
    {
      "token": invalid_sme_token,
      "refreshToken": refresh_token
    }
  end

  describe 'Authenticate in SME' do
    it 'return TRUE if VALID credentials' do
      stub_request(:post, "#{ENV['SME_CORE_SSO_API']}/api/v1/autenticacao").
       with(
         body: "{\"login\":\"#{rf_code}\",\"senha\":\"#{user.password}\"}",
         headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json-patch+json',
          'User-Agent'=>'Ruby',
          'X-Api-Eol-Key'=> "#{ENV['CORE_SSO_AUTHENTICATION_TOKEN']}"
         }).to_return(
           status: 200,
           body: {
             usuarioId: "1", status: 0, nome: user.username, codigoRf: rf_code,
             perfis: [ "string" ], possuiCargoCJ: true, possuiPerfilCJ: true
           }.to_json,
           headers: {}
         )

      stub_request(:get, "#{ENV['SME_SGP_API']}/api/AutenticacaoSgp/#{rf_code}/dados").
        to_return(
          status: 200,
          body: {
            cpf: "31388275864",
            nome: "Fulano de Tal",
            codigoRf: "1234567",
            email: "fulano.tal@sme.prefeitura.sp.gov.br",
            dreCodigos: [
              123456
            ],
            emailValido: true
          }.to_json,
          headers: {}
        )

      expected = User.authenticate_in_sme credentials

      expect(expected).to eq({:message=>"Created", :status=>201})
    end

    it 'return FALSE if INVALID credentials' do
      stub_request(:post, "#{ENV['SME_CORE_SSO_API']}/api/v1/autenticacao").
       with(
         body: "{\"login\":\"#{rf_code}\",\"senha\":\"WRONG\"}",
         headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json-patch+json',
          'User-Agent'=>'Ruby',
          'X-Api-Eol-Key'=> "#{ENV['CORE_SSO_AUTHENTICATION_TOKEN']}"
         }).to_return(
           status: 401,
           body: { error: "Usuário ou senha incorretos." }.to_json,
           headers: {}
         )

      expected = User.authenticate_in_sme invalid_credentials
      expect(expected).to eq({ :status=> 401, :message=> "{\"error\":\"Usuário ou senha incorretos.\"}" })
    end
  end
end
