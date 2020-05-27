json.stages @stages do |stage|
  json.id stage.id
  json.name stage.name
  json.color stage.segment.color
end
