require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  let(:user) { create :user }
  let(:rf_code) { '123456' }
  let(:valid_attributes) { { login: rf_code, password: user.password } }
  let(:invalid_attributes) { { login: rf_code, password: 'wrong_password' } }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end


  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new session' do
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
              results: [
                {
                  cd_registro_funcional: "1234567",
                  nm_pessoa: "Fulano de Tal",
                  email_servidor: "fulano.tal@sme.prefeitura.sp.gov.br",
                  cd_diretoria_cargo_atual: "123456",
                  nm_exibicao_unidade: "DRE - Qualquer",
                  nm_unidade: "DIRETORIA REGIONAL DE EDUCACAO LUGAR/NENHUM"
                }
              ]
            }.to_json,
            headers: {}
          )

        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'returns http unauthorized' do
      it 'renders a JSON response with errors for the new session' do
        stub_request(:post, "#{ENV['SME_CORE_SSO_API']}/api/v1/autenticacao").
         with(
           body: "{\"login\":\"#{rf_code}\",\"senha\":\"wrong_password\"}",
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


        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
