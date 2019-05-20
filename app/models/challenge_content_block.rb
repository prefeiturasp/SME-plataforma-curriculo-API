class ChallengeContentBlock < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  belongs_to :challenge
end
