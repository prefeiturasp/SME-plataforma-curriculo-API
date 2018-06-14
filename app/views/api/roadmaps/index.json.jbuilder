json.array! @roadmaps do |roadmap|
  json.id roadmap.id
  json.title roadmap.title
  json.description roadmap.description
  json.status Roadmap.human_enum_name(:status, roadmap.status)
end
