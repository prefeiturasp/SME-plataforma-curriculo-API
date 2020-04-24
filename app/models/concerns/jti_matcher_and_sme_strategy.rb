module JtiMatcherAndSmeStrategy
  extend ActiveSupport::Concern

  included do
    before_create :initialize_jti

    def self.jwt_revoked?(payload, user)
      user.invalid_payload?(payload)
    end

    def self.revoke_jwt(_payload, user)
      user.update_column(:jti, generate_jti)
    end

    def self.generate_jti
      SecureRandom.uuid
    end
  end

  def jwt_payload
    { 'jti' => jti, 'username' => username }
  end

  def invalid_payload?(payload)
    payload['jti'] != jti || payload['username'] != username
  end

  private

  def initialize_jti
    self.jti = self.class.generate_jti
  end
end
