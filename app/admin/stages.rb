ActiveAdmin.register Stage do
  permit_params :name, :sequence, :segment_id

  config.filters = true
  config.sort_order = 'sequence_asc'

  controller do
    def destroy
      @stage = Stage.find(params[:id])
      flash[:error] = @stage.errors.full_messages.join(',') unless @stage.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    f.inputs do
      f.input :segment, required: true
      f.input :name, required: true
      f.input :sequence,
              as: :select,
              collection: sequence_options(Stage),
              selected: stage.sequence.present? ? stage.sequence : sequence_options(Stage).last
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :sequence
    column :name
    column :segment
    actions
  end

  show do
    attributes_table do
      row :id
      row :sequence
      row :name
      row :segment
    end
  end
end
