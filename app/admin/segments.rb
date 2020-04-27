ActiveAdmin.register Segment do
  permit_params :name

  config.filters = true

  controller do
    def destroy
      @segment = Segment.find(params[:id])
      flash[:error] = @segment.errors.full_messages.join(',') unless @segment.destroy
      redirect_to action: :index
    end
  end

  form do |f|
    f.inputs do
      f.input :name, required: true
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
    end
  end
end
