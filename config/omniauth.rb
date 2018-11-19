namespace1 = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims"
namespace2 = "http://schemas.microsoft.com/identity/claims"
attributes_map = {
  uid: ["#{namespace2}/objectidentifier"],
  name: ["#{namespace2}/displayname"],
  email: ["#{namespace1}/emailaddress"]
}

# config.omniauth :saml,
#   issuer: "#{ENV['SAML_CALLBACK_ADDRESS']}/users/saml/metadata",
#   idp_sso_target_url: ENV['SAML_SSO_AUTH_URL'],
#   idp_slo_target_url: ENV['SAML_SLO_AUTH_URL'],
#   assertion_consumer_service_url: "#{ENV['SAML_CALLBACK_ADDRESS']}/api/v1/auth/saml",
#   assertion_consumer_service_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST",
#   name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:transient",
#   idp_cert: "-----BEGIN CERTIFICATE-----
#   MIID2DCCAsCgAwIBAgIUUrnXXZzxm4lOxGnFDLEKjCRfyIUwDQYJKoZIhvcNAQEF
#   BQAwRDEPMA0GA1UECgwGSnVyZW1hMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAY
#   BgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMB4XDTE4MTExMjE5MDcyOFoXDTIzMTEx
#   MjE5MDcyOFowRDEPMA0GA1UECgwGSnVyZW1hMRUwEwYDVQQLDAxPbmVMb2dpbiBJ
#   ZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMIIBIjANBgkqhkiG9w0BAQEF
#   AAOCAQ8AMIIBCgKCAQEAvfdKGatKYC6RNrlg4e+Vs+EAiVF0DLxfNJUHI+ZAyeI2
#   Yy1LAl7tRGEQ3X+SiwvIxlPlpkuszrFLq8V6HDO6YHNU4q6wQDHaak5692efVi96
#   QPq4VqoNGSuGmhncW9j2t3LeOehQv213l4JryWFAMe1jfVq9XmDls2P/E23j0i0g
#   vBoqFm+ZSTbq2+A/U67rLWCZ6t0bLxYrjgiBf+LtMYQcDNYX08o2yot2Ys46Ac9M
#   k8JTVOZ9dF54Ss14ENJJF4Lr5CvaXDCUZzhphUs5wHKXQyl+VtsgH6enKCoS8QAh
#   g1XkOWCMtgd+ftS22jAXqnT9DgZRSImoXZMyMhtQqQIDAQABo4HBMIG+MAwGA1Ud
#   EwEB/wQCMAAwHQYDVR0OBBYEFMPFV9sdrVXd/svXQgGjCZpg469wMH8GA1UdIwR4
#   MHaAFMPFV9sdrVXd/svXQgGjCZpg469woUikRjBEMQ8wDQYDVQQKDAZKdXJlbWEx
#   FTATBgNVBAsMDE9uZUxvZ2luIElkUDEaMBgGA1UEAwwRT25lTG9naW4gQWNjb3Vu
#   dCCCFFK5112c8ZuJTsRpxQyxCowkX8iFMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG
#   9w0BAQUFAAOCAQEAs/xC2/niN+LYfZOaJAfAGn7PWYK27zuKE+FZGs/bblFrxznT
#   BTDlZC+gpJVby0z2EEc3x9QIOkDJXtt3rfDmPad7ImdK8jLpLLnrH3ziWDcDf2hQ
#   YHZ7asg+q9+xLKVu2/1WtsddhaZ9Zb5DNc9SYPIeLOZAdjBMMNLgpwEMgeJ8NPYl
#   b7Lw5jxCdCoHpTR9f468sL27azbh7T5ACL9fWb2f6AGTt0t6gtXWeqagKUkTay68
#   D6UiijmDrpbvHeQcqJw4Q0MYiv53q4wmJgU5AtPCgtHjbVt3faslnI4W7Mz6rt7w
#   H9TDXMjz80GUHGNGoXuPiQRIX6ebcZaL+YgUCQ==
#   -----END CERTIFICATE-----
#   ",
#   idp_cert_fingerprint: ENV['SAML_CERT_FINGERPRINT'],
#   idp_cert_fingerprint_algorithm: ENV['SAML_SAML_CERT_FINGERPRINT_ALGORITHM']


# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :saml,
#            issuer: ENV['SAML_ISSUER_URL'],
#            idp_sso_target_url: ENV['SAML_SSO_AUTH_URL'],
#            idp_slo_target_url: ENV['SAML_SLO_AUTH_URL'],
#            attribute_statements: attributes_map,
#            idp_cert_fingerprint:  ENV['SAML_CERT_FINGERPRINT'],
#            idp_cert_fingerprint_algorithm: ENV['SAML_SAML_CERT_FINGERPRINT_ALGORITHM'],
#            name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:transient",
#            uid_attribute: attributes_map[:uid].first
# end


  # config.saml_configure do |settings|

  #   settings.assertion_consumer_service_url = "#{ENV['SAML_CALLBACK_ADDRESS']}/users/saml/auth"
  #   settings.issuer = "#{ENV['SAML_CALLBACK_ADDRESS']}/users/saml/metadata"
  #   # settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
  #   # settings.name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
  #   # settings.authn_context                      = ""

  #   settings.idp_entity_id = ENV['SAML_ISSUER_URL']
  #   settings.idp_sso_target_url = ENV['SAML_SSO_AUTH_URL']
  #   settings.idp_slo_target_url = ENV['SAML_SLO_AUTH_URL']
  #   settings.idp_cert_fingerprint = ENV['SAML_CERT_FINGERPRINT']
  #   settings.idp_cert_fingerprint_algorithm = ENV['SAML_SAML_CERT_FINGERPRINT_ALGORITHM']
  # end