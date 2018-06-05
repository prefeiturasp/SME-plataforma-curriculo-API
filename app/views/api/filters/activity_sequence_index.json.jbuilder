json.years @years do |year|
  json.id year.first
  json.description t("activerecord.attributes.enums.years.#{year.first}")
end

json.curricular_components @curricular_components do |curricular_component|
  json.id curricular_component.friendly_id
  json.name curricular_component.name
end

json.sustainable_development_goals @sustainable_development_goals do |sds|
  json.id sds.id
  json.sequence sds.sequence
  json.name sds.name
  json.url url_for(sds.icon)
end

json.knowledge_matrices @knowledge_matrices do |knowledge_matrix|
  json.id knowledge_matrix.id
  json.sequence knowledge_matrix.sequence
  json.title knowledge_matrix.title
end

json.learning_objectives @learning_objectives do |learning_objective|
  json.id learning_objective.id
  json.code learning_objective.code
  json.description learning_objective.description
end

json.axes @axes do |axis|
  json.id axis.id
  json.description axis.description
end

json.activity_types @activity_types do |activity_type|
  json.id activity_type.id
  json.name activity_type.name
end
