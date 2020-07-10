class Answer < ApplicationRecord
  belongs_to :survey_form_answer
  belongs_to :survey_form_content_block
  belongs_to :teacher
end
