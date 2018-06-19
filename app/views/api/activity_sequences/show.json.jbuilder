json.slug @activity_sequence.slug
json.title @activity_sequence.title
json.year t("activerecord.attributes.enums.years.#{@activity_sequence.year}")
json.main_curricular_component @activity_sequence.main_curricular_component.name
json.estimated_time @activity_sequence.estimated_time
json.status @activity_sequence.status

json.curricular_components @activity_sequence.curricular_components do |curricular_component|
  json.name curricular_component.name
end

json.knowledge_matrices @activity_sequence.knowledge_matrices do |knowledge_matrix|
  json.sequence knowledge_matrix.sequence
  json.title knowledge_matrix.title
end

json.learning_objectives @activity_sequence.learning_objectives do |learning_objective|
  json.code learning_objective.code
  json.description learning_objective.description
end

json.sustainable_development_goals @activity_sequence.sustainable_development_goals do |sds|
  json.icon_url variant_url(sds.icon, :icon)
end

json.books @activity_sequence.books

json.image variant_url(@activity_sequence.image, :large)
json.presentation_text @activity_sequence.presentation_text

json.activities @activity_sequence.activities do |activity|
  json.slug activity.slug
  json.image variant_url(activity.image, :small)
  json.title activity.title
  json.estimated_time activity.estimated_time
end
