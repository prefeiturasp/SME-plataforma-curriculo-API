class SurveyFormAnswer < ApplicationRecord
  belongs_to :survey_form
  belongs_to :teacher
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true

end
