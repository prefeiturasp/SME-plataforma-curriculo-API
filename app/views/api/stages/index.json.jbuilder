json.array! @stages do |stage|
  json.id stage.id
  json.name stage.name
  json.segment_name stage.segment.name
  json.segment_id stage.segment.id
end
