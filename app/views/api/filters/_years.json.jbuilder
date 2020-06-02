json.years @years do |year|
  json.id year.id
  json.name year.name
  json.color year.stage.segment.color
end
