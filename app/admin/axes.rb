ActiveAdmin.register Axis do
  permit_params :description, :curricular_component_id

  config.filters = false
end
