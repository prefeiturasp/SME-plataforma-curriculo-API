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
    if response.code == 200
      body = JSON.parse(response.body, symbolize_names: true)
      User.find_or_create_by_auth_params(body, credentials)
    else
      false
    end
  rescue StandardError => e
    Rails.logger.error(e)
    false
  end

  def self.find_or_create_by_auth_params(body, credentials)
    user = User.find_or_create_by(username: body[:codigoRf])
    user_info = User.get_info_from_sme(body[:codigoRf])
    user.name = user_info[:nome]
    user.email = user_info[:email]
    user.password = credentials[:senha]
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

  private

  def assign_teacher
    create_teacher if username.present? && teacher.nil?
  end
end
