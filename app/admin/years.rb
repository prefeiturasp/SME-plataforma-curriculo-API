ActiveAdmin.register Year do
  permit_params :name, :segment_id, :stage_id

  config.filters = true

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
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column :segment
    column :stage
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :segment
      row :stage
    end
  end
end
