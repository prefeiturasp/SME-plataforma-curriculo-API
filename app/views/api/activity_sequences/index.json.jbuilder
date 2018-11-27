json.array! @activity_sequences do |activity_sequence|
  json.id activity_sequence.id
  json.slug activity_sequence.slug
  json.title activity_sequence.title
  json.estimated_time activity_sequence.estimated_time
  json.status activity_sequence.status
  json.number_of_activities activity_sequence.activities.count
  json.partial! 'api/images/image', image_param: activity_sequence.image, sizes: %i[thumb extra_thumb]
  json.year ActivitySequence.human_enum_name(:year, activity_sequence.year, true)
  json.keywords activity_sequence.keywords
  json.sequence activity_sequence.collection_activity_sequences.find_by(collection_id: @collection.id).sequence if @collection

  json.main_curricular_component do
    json.name activity_sequence.main_curricular_component.name
    json.color activity_sequence.main_curricular_component.color
  end

  json.knowledge_matrices activity_sequence.knowledge_matrices do |knowledge_matrix|
    json.sequence knowledge_matrix.sequence
    json.title knowledge_matrix.title
  end

  json.learning_objectives activity_sequence.learning_objectives do |learning_objective|
    json.code learning_objective.code
    json.color learning_objective.curricular_component.color
  end

  json.sustainable_development_goals activity_sequence.sustainable_development_goals do |sds|
    json.name sds.name
    json.icon_url variant_url(sds.icon, :icon)
    json.sub_icon_url url_for(sds.sub_icon)
  end
end
