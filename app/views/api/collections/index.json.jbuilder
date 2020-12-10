json.array! @collections do |collection|
  json.id collection.id
  json.name collection.name
  json.teacher_id collection.teacher_id
  json.number_of_classes collection.number_of_classes
  json.number_of_activity_sequences collection.number_of_published_activity_sequences
  json.number_of_projects collection.number_of_projects
end
