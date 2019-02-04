class SMEAuthentication < Flexirest::Base
  base_url ENV['SME_AUTHENTICATION_BASE_URL']
  request_body_type :json

  post :login,         '/LoginJWT'
  post :refresh_token, '/RefreshLoginJWT'
end
