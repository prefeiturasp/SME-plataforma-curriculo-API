class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User

  devise :omniauthable, omniauth_providers: [:saml]

  def self.from_omniauth(auth)
    return unless auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.uid
      user.password = Devise.friendly_token[0,20]
    end
  end

end
