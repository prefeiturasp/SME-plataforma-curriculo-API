json.array! @years do |year|
  json.id year.id
  json.name year.name
  json.segment_name year.segment.name
  json.segment_id year.segment.id
  json.stage_id year.stage.id
end
