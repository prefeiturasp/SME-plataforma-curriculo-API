json.sequence @activity.sequence
json.title @activity.title
json.estimated_time @activity.estimated_time
json.environment @activity.environment
json.partial! 'api/images/image', image_param: @activity.image, sizes: %i[large extra_large]

json.next_object @activity.next_object.try(:slug)
json.last_object @activity.last_object.try(:slug)

json.content @activity.content

json.activity_sequence do
  json.slug @activity.activity_sequence.slug
  json.title @activity.activity_sequence.title
  json.year @activity.activity_sequence.year.name if @activity.activity_sequence.year.present?
  json.main_curricular_component do
    json.name @activity.activity_sequence.main_curricular_component.name
    json.color @activity.activity_sequence.main_curricular_component.color
  end
  json.partial! 'api/images/image', image_param: @activity.activity_sequence.image, sizes: %i[thumb extra_thumb]
end

json.curricular_components @activity.curricular_components do |curricular_component|
  json.name curricular_component.name
end

json.learning_objectives @activity.learning_objectives do |learning_objective|
  json.code learning_objective.code
  json.description learning_objective.description
  json.color learning_objective.curricular_component.color
end

json.content_blocks @activity.activity_content_blocks do |activity_content_block|
  json.type activity_content_block.content_block.content_type
  json.content activity_content_block.content_hash if activity_content_block.content_hash.present?
  if activity_content_block.images.present?
    json.images activity_content_block.images do |image|
      json.subtitle image.subtitle
      json.partial!('api/images/image', image_param: image.file, sizes: %i[medium] )
    end
  end
end
