json.array! @collections do |collection|
  json.id collection.id
  json.name collection.name
  json.teacher_id collection.teacher_id
  json.number_of_activity_sequences collection.activity_sequences.published.count
  json.number_of_classes rand(1..10)
end
