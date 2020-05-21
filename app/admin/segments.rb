ActiveAdmin.register Segment do
  permit_params :name,
                :color

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
      f.input :color, as: :color
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column :color do |segment|
      raw "<div class='pick_color'>#{segment.color}</div>"
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :color do |segment|
        raw "<div class='pick_color'>#{segment.color}</div>"
      end
    end
  end
end
