json.curricular_components @curricular_components do |curricular_component|
  json.id curricular_component.friendly_id
  json.name curricular_component.name
end
