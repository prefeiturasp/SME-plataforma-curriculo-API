json.survey_form @survey_form
json.survey_form_content_blocks @survey_form_content_blocks.each do |survey_form_content_block|
  json.type survey_form_content_block.content_block.content_type
  json.id survey_form_content_block.id
  json.survey_form_id survey_form_content_block.survey_form_id
  json.content survey_form_content_block.content_hash if survey_form_content_block.content_hash.present?
end
