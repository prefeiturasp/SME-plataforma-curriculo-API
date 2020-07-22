class SurveyFormContentBlock < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  belongs_to :survey_form
  has_many :answers, dependent: :restrict_with_error
end
