class SurveyFormContentBlock < ApplicationRecord
  include ConvertImageConcern
  include ContentBlockConcern

  belongs_to :survey_form
end
