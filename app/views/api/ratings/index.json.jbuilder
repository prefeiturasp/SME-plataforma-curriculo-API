json.array! @ratings do |rating|
  json.id rating.id
  json.sequence rating.sequence
  json.description rating.description
  json.enable rating.enable?
end
