ActiveAdmin.register KnowledgeMatrix do
  permit_params :title, :know_description, :for_description, :sequence
  config.sort_order = 'sequence_asc'

  index do
    selectable_column
    column :sequence
    column :title
    column :know_description
    column :for_description
    column :created_at
    column :updated_at

    actions
  end
end
