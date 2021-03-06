json.array! @public_consultations do |public_consultation|
  json.id public_consultation.id
  json.segment public_consultation.segment.name
  json.title public_consultation.title
  json.description public_consultation.description
  json.cover_image "/assets/#{public_consultation.cover_image_identifier}"
  json.documents public_consultation.documents_identifiers.map {|d| "/assets/#{d}"}
  json.initial_date (public_consultation.initial_date.to_i * 1000)
  json.final_date (public_consultation.final_date.to_i * 1000)
  json.survey_forms public_consultation.survey_forms
end
