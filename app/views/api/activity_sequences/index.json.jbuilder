json.array! @activity_sequences do |activity_sequence|
  json.id activity_sequence.id
  json.slug activity_sequence.slug
  json.title activity_sequence.title
  json.estimated_time activity_sequence.estimated_time
  json.status activity_sequence.status
  json.number_of_activities activity_sequence.activities.count
  json.image variant_url(activity_sequence.image, :medium)
  json.year ActivitySequence.human_enum_name(:year, activity_sequence.year, true)

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
    json.sub_icon_url variant_url(sds.sub_icon, :icon) #TODO verify size
  end
end
