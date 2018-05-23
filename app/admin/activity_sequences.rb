ActiveAdmin.register ActivitySequence do
  permit_params :title,
  :presentation_text,
  :books,
  :estimated_time,
  :status,
  curricular_component_ids: []

  # :main_curricular_component

end
