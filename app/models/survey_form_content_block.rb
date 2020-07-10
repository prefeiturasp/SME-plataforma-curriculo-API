class SurveyFormContentBlock < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  belongs_to :survey_form
  has_many :answers, dependent: :destroy
end
