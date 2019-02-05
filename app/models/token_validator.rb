class TokenValidator
  attr_reader :token, :refresh_token

  def initialize(token, refresh_token = nil)
    @token = token
    @refresh_token = refresh_token
    @time = Time.now.to_i
  end

  def username
    jwt[:username]
  end

  def jti
    jwt[:jti]
  end

  def token_exists?
    !jwt.nil? && !jwt.blank?
  end

  def token_valid_iss?
    return false if jwt[:iss].blank?
    URI.parse(jwt[:iss]).host == URI.parse(ENV['SME_JWT_ISSUER']).host
  end

  def token_valid_aud?
    return false if jwt[:aud].blank?
    URI.parse(jwt[:aud]).host == URI.parse(ENV['SME_JWT_AUDIENCE']).host
  end

  def token_fresh?
    jwt[:exp] > @time
  end

  VALIDATORS = %i[
    token_exists?
    token_valid_iss?
    token_valid_aud?
    token_fresh?
  ].freeze

  def valid?
    VALIDATORS.all? do |expectation|
      send(expectation) ? true : false
    end
  end

  private

  def jwt
    return @jwt if defined? @jwt

    @jwt = JWT.decode(@token, nil, false)[0].symbolize_keys
  rescue StandardError
    @jwt = nil
  end
end
