class User < ApplicationRecord
  include JtiMatcherAndSmeStrategy
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :teacher, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_writer :login

  after_create :assign_teacher

  def login
    @login || username || email
  end

  def self.authenticate_in_sme(credentials)
    return unless credentials

    response = SMEAuthentication.login(credentials)
    verifier = TokenValidator.new(response.token, response.refreshToken)
    return unless verifier.valid?

    User.find_or_create_by_auth_params(verifier, credentials)
  rescue StandardError => e
    Rails.logger.error(e)
    false
  end

  def self.find_or_create_by_auth_params(token_validator, credentials)
    user = User.find_or_create_by(username: token_validator.username)
    user.password = credentials['password']
    user.sme_token = token_validator.token
    user.sme_refresh_token = token_validator.refresh_token
    user.save
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_hash)
        .where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
        .first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  def refresh_sme_token!
    return false if valid_sme_token?

    response = SMEAuthentication.refresh_token(refresh_token_params)
    verifier = TokenValidator.new(response.token, response.refreshToken)
    return !revoke_jwt! unless verifier.valid?

    update(sme_token: verifier.token, sme_refresh_token: verifier.refresh_token)
  rescue StandardError
    revoke_jwt!
    false
  end

  def refresh_token_params
    { username: username, refreshToken: sme_refresh_token }
  end

  private

  def assign_teacher
    create_teacher if username.present? && teacher.nil?
  end
end
