class User < ApplicationRecord
  include JtiMatcherAndSmeStrategy
  include HTTParty
  base_uri ENV['SME_AUTHENTICATION_BASE_URL']
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :teacher, dependent: :destroy

  validates :email, presence: true, if: -> { username.blank? }
  validates :email, uniqueness: { case_sensitive: false }, if: -> { email.present? }
  validates :username, presence: true, if: -> { email.blank? }

  validates_uniqueness_of :username, case_sensitive: false, if: -> { username.present? }

  attr_writer :login
  attr_accessor :_skip_creating_teacher

  after_create :assign_teacher, unless: :_skip_creating_teacher

  def login
    @login || username || email
  end

  def self.authenticate_in_sme(credentials)
    response = HTTParty.post(
      "#{base_uri}/api/AutenticacaoSgp/Autenticar",
      { body: credentials.symbolize_keys }
    )
    body = JSON.parse(response.body, symbolize_names: true)
    User.find_or_create_by_auth_params(body, credentials) if response.code == 200
  rescue StandardError => e
    Rails.logger.error(e)
    false
  end

  def self.find_or_create_by_auth_params(body, credentials)
    user = User.find_or_create_by(username: body[:codigoRf])
    info = User.get_info_from_sme(body[:codigoRf])
    user.email = info[:email]
    user.password = credentials[:senha]
    user.email = "test@email.com.br" if user.email.nil?
    user.teacher = Teacher.find_or_create_by(name: body[:nome]) if body[:nome].present?
    user.save
  end

  def self.get_info_from_sme(rf_code)
    response = HTTParty.get(
      "#{base_uri}/api/AutenticacaoSgp/#{rf_code}/dados"
    )
    body = JSON.parse(response.body, symbolize_names: true)
    body
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
    update_user_from_sme_response(response)
  rescue StandardError
    refresh_sme_token_fail
  end

  def update_user_from_sme_response(response)
    verifier = TokenValidator.new(response.token, response.refreshToken)
    if verifier.valid?
      update(sme_token: verifier.token, sme_refresh_token: verifier.refresh_token)
    else
      refresh_sme_token_fail
    end
  end

  def refresh_token_params
    { username: username, refreshToken: sme_refresh_token }
  end

  private

  def assign_teacher
    create_teacher if username.present? && teacher.nil?
  end

  def refresh_sme_token_fail
    revoke_jwt! ? false : true
  end
end
