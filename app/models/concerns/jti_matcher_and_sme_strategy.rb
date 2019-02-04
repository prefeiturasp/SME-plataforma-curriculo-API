module JtiMatcherAndSmeStrategy
  extend ActiveSupport::Concern

  included do
    before_create :initialize_jti

    def self.jwt_revoked?(payload, user)
      Rails.logger.debug("jwt1 "*40)
      payload['jti'] != user.jti
    end

    def self.revoke_jwt(_payload, user)
      Rails.logger.debug("jwt2 "*40)
      user.update_column(:jti, generate_jti)
    end

    def self.generate_jti
      SecureRandom.uuid
    end
  end

  def jwt_payload
    { 'jti' => jti }
  end

  private

  def initialize_jti
    self.jti = self.class.generate_jti
  end
end
