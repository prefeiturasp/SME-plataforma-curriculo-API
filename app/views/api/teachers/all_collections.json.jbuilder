json.array! @collections do |collection|
  json.id collection.id
  json.name collection.name
  json.activity_sequences collection.activity_sequences do |activity_sequence|
    json.id activity_sequence.id
    json.slug activity_sequence.slug
    json.title activity_sequence.title
  end
  json.classes []
end
