Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
          idp_cert_fingerprint:  ENV['SAML_CERT_FINGERPRINT'],
          idp_sso_target_url: ENV['SAML_SSO_AUTH_URL'],
          idp_cert_fingerprint_algorithm: ENV['SAML_SAML_CERT_FINGERPRINT_ALGORITHM'],
          idp_slo_target_url: ENV['SAML_SLO_AUTH_URL'],
          slo_default_relay_state: "#{ENV['SAML_CALLBACK_ADDRESS']}/api/auth/sign_out",
          single_logout_service_url: "#{ENV['SAML_CALLBACK_ADDRESS']}/api/auth/saml/slo",
          idp_entity_id: ENV['SAML_ISSUER_URL'],
          idp_slo_session_destroy: proc { |_env, session|
            User.reset_token_from_idp(session['saml_uid'])
          }
end
