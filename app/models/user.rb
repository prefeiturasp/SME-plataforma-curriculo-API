class User < ApplicationRecord
  devise :saml_authenticatable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable
end
