json.axes @axes do |axis|
  json.id axis.id
  json.description axis.description
end

json.learning_objectives @learning_objectives do |learning_objective|
  json.id learning_objective.id
  json.code learning_objective.code
  json.description learning_objective.description
end
