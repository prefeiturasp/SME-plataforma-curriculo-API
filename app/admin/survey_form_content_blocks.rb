ActiveAdmin.register SurveyFormContentBlock do
  belongs_to :survey_form

  permit_params :survey_form_id,
                :content_block_id,
                :content

  config.filters = false

  collection_action :set_order, method: :post do
    survey_form = SurveyForm.find_by(id: params[:survey_form_id])
    survey_form_content_block_ids = params[:survey_form_content_block_ids].reject(&:empty?)
    survey_form_content_block_ids.each.with_index(1) do |survey_form_content_block_id, sequence|
      survey_form_content_block = survey_form.survey_form_content_blocks.find_by(id: survey_form_content_block_id)
      next unless survey_form_content_block
      survey_form_content_block.sequence = sequence
      survey_form_content_block.save
    end

    render json: {}
  end

  index do
    selectable_column
    column :content_block
    actions
  end

  show do
    attributes_table do
      row :content_block
    end
  end
end
