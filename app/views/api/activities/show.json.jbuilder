json.sequence @activity.sequence
json.title @activity.title
json.estimated_time @activity.estimated_time
json.environment @activity.environment
json.partial! 'api/images/image', image_param: @activity.image, sizes: %i[large extra_large]

json.next_activity @activity.next_activity.try(:slug)
json.last_activity @activity.last_activity.try(:slug)

json.content @activity.content

json.activity_sequence do
  json.slug @activity.activity_sequence.slug
  json.title @activity.activity_sequence.title
  json.year ActivitySequence.human_enum_name(:year, @activity.activity_sequence.year, true)
  json.main_curricular_component do
    json.name @activity.activity_sequence.main_curricular_component.name
    json.color @activity.activity_sequence.main_curricular_component.color
  end
end

json.activity_types @activity.activity_types do |activity_type|
  json.name activity_type.name
end

json.curricular_components @activity.curricular_components do |curricular_component|
  json.name curricular_component.name
end

json.learning_objectives @activity.learning_objectives do |learning_objective|
  json.code learning_objective.code
  json.description learning_objective.description
  json.color learning_objective.curricular_component.color
end

json.activity_content_blocks @activity.activity_content_blocks do |activity_content_block|
  json.type activity_content_block.content_block.content_type
  json.content activity_content_block.content_hash
end
