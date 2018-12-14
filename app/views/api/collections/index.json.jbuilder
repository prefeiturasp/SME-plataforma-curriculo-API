json.array! @collections do |collection|
  json.id collection.id
  json.name collection.name
  json.teacher_id collection.teacher_id
end
