json.array! @learning_objectives do |learning_objective|
  json.id learning_objective.id
  json.code learning_objective.code
  json.description learning_objective.description
  json.curricular_component_id learning_objective.curricular_component_id
  json.segment_id learning_objective.segment_id
  json.stage_id learning_objective.stage_id
  json.year_id learning_objective.year_id
end
