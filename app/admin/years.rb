ActiveAdmin.register Year do
  permit_params :name, :sequence, :segment_id, :stage_id

  config.filters = true
  config.sort_order = 'sequence_asc'

  controller do
    def destroy
      @year = Year.find(params[:id])
      flash[:error] = @year.errors.full_messages.join(',') unless @year.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    f.inputs do
      f.input :segment, required: true
      f.input :stage,
              required: true,
              collection: year.segment.present? \
                          ? stage_collection(year.segment.id)
                          : [t('Selecione um segmento'), nil]
      f.input :name, required: true
      f.input :sequence,
              as: :select,
              collection: sequence_options(Year),
              selected: year.sequence.present? ? year.sequence : sequence_options(Year).last
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :sequence
    column :name
    column :segment
    column :stage
    actions
  end

  show do
    attributes_table do
      row :id
      row :sequence
      row :name
      row :segment
      row :stage
    end
  end
end
