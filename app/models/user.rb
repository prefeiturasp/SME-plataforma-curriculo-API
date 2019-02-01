class User < ApplicationRecord
  include JtiMatcherAndSmeStrategy

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :jwt_authenticatable, { jwt_revocation_strategy: self }

  has_one :teacher, dependent: :destroy
end
