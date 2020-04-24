ActiveAdmin.register Stage do
  permit_params :name, :segment_id

  config.filters = true

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
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column :segment
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :segment
    end
  end
end
