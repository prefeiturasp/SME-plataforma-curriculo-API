json.id @activity_sequence.id
json.slug @activity_sequence.slug
json.title @activity_sequence.title
json.year @activity_sequence.year.name if @activity_sequence.year.present?
json.estimated_time @activity_sequence.estimated_time
json.status @activity_sequence.status
json.keywords @activity_sequence.keywords
json.sequence @activity_sequence.collection_activity_sequences.find_by(collection_id: @collection.id).sequence if @collection
json.already_saved_in_collection @activity_sequence.already_saved_in_collection? current_teacher if current_teacher

json.main_curricular_component do
  json.name @activity_sequence.main_curricular_component.name
  json.color @activity_sequence.main_curricular_component.color
end

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
  json.color learning_objective.curricular_component.color
end

json.sustainable_development_goals @activity_sequence.sustainable_development_goals do |sds|
  json.id sds.id
  json.name sds.name
  json.icon_url variant_url(sds.icon, :icon)
  json.sub_icon_url url_for(sds.sub_icon)
end

json.books @activity_sequence.books
json.partial! 'api/images/image', image_param: @activity_sequence.image, sizes: %i[large extra_large]
json.presentation_text @activity_sequence.presentation_text

json.activities @activity_sequence.activities do |activity|
  json.slug activity.slug
  json.title activity.title
  json.estimated_time activity.estimated_time
  json.partial! 'api/images/image', image_param: activity.image, sizes: %i[small extra_small]
end

json.partial! 'api/activity_sequence_performeds/status', activity_sequence: @activity_sequence if current_teacher
