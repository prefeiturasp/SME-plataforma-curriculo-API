class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:saml]

  include DeviseTokenAuth::Concerns::User

  has_one :teacher, dependent: :destroy

  def self.from_omniauth(auth)
    return unless auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.uid
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.reset_token_from_idp(uid)
    user = find_by(uid: uid)
    return true unless user
    user.tokens = {}
    user.save!
  end

  def send_reset_password_instructions
    return false if provider.present? & !admin?
    super
  end
end
