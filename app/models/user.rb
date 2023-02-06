class User < ApplicationRecord
  include JtiMatcherAndSmeStrategy
  include HTTParty
  base_uri ENV['SME_CORE_SSO_API']
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  attribute :admin, default: false
  attribute :superadmin, default: false
  has_one :teacher, dependent: :destroy
  has_and_belongs_to_many :regional_education_boards
  has_and_belongs_to_many :permitted_actions

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
    User.core_sso_authenticate(credentials)
  end

  def self.core_sso_authenticate(credentials)
    uri = URI.parse("#{base_uri}/api/v1/autenticacao")
    headers = {
      "x-api-eol-key": "#{ENV['CORE_SSO_AUTHENTICATION_TOKEN']}",
      "Content-Type": "application/json-patch+json"
    }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.post(uri.path, credentials.to_json, headers)

    if response.code.to_i == 200
      body = JSON.parse(response.body, symbolize_names: true)
      User.find_or_create_by_auth_params(body, credentials)
    else
      { status: response.code.to_i, message: response.body}
    end
  end

  def self.find_or_create_by_auth_params(body, credentials)
    user_info = User.get_info_from_sme(credentials[:login])
    if user_info.nil?
      { status: 403, message: "As informações do usuário não foram encontradas na smeintegracaoapi"}
    else
      user = User.find_or_create_by(username: credentials[:login])
      user.password = credentials[:senha]
      user.name = user_info[:nome]
      user.email = user_info[:email]
      user.dre = user_info[:dreCodigos]? user_info[:dreCodigos].first() : []
      user.regional_education_boards = RegionalEducationBoard.where(code: user_info[:dreCodigos])
      user.save
      { status: 201, message: "Created"}
    end
  end

  def self.get_info_from_sme(rf_code)
    headers = {
      "x-api-eol-key": "#{ENV['CORE_SSO_AUTHENTICATION_TOKEN']}",
      "Content-Type": "application/json-patch+json"
    }
    response = HTTParty.get("#{ENV['SME_SGP_API']}/api/AutenticacaoSgp/#{rf_code}/dados", headers: headers)
    body = JSON.parse(response.body, symbolize_names: true)
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
