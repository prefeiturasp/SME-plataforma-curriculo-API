Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
          idp_cert_fingerprint:  ENV['SAML_CERT_FINGERPRINT'],
          idp_sso_target_url: ENV['SAML_SSO_AUTH_URL'],
          idp_cert_fingerprint_algorithm: ENV['SAML_SAML_CERT_FINGERPRINT_ALGORITHM']
end
