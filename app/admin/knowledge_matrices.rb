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

  form do |f|
    f.inputs do
      f.input :sequence,
        as: :select,
        collection: sequence_options(KnowledgeMatrix),
        selected: knowledge_matrix.sequence.present? ? knowledge_matrix.sequence : sequence_options(KnowledgeMatrix).last
      f.input :title
      f.input :know_description
      f.input :for_description
    end
    f.actions
  end
end
