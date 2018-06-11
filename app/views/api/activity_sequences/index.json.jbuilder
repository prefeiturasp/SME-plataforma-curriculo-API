json.array! @activity_sequences do |activity_sequence|
  json.id activity_sequence.id
  json.slug activity_sequence.slug
  json.title activity_sequence.title
  json.main_curricular_component activity_sequence.main_curricular_component.name
  json.estimated_time activity_sequence.estimated_time
  json.status activity_sequence.status
  json.number_of_activities activity_sequence.activities.count
  json.image url_for(activity_sequence.image)

  json.knowledge_matrices activity_sequence.knowledge_matrices do |knowledge_matrix|
    json.sequence knowledge_matrix.sequence
    json.title knowledge_matrix.title
  end

  json.learning_objectives activity_sequence.learning_objectives do |learning_objective|
    json.code learning_objective.code
  end

  json.sustainable_development_goals activity_sequence.sustainable_development_goals do |sds|
    json.icon_url url_for(sds.icon)
  end
end
