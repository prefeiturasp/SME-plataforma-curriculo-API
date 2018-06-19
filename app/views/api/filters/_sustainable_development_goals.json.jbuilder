json.sustainable_development_goals @sustainable_development_goals do |sds|
  json.id sds.id
  json.sequence sds.sequence
  json.name sds.name
  json.url variant_url(sds.icon, :icon)
end
