json.id @public_consultation.id
json.segment @public_consultation.segment
json.title @public_consultation.title
json.description @public_consultation.description
json.color @public_consultation.segment.color
json.cover_image "/assets/#{@public_consultation.cover_image_identifier}"
json.documents @public_consultation.documents_identifiers.map {|d| "/assets/#{d}"}
json.initial_date @public_consultation.initial_date.strftime("%d/%m/%Y")
json.final_date @public_consultation.final_date.strftime("%d/%m/%Y")
json.survey_forms @public_consultation.survey_forms
