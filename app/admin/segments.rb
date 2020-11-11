ActiveAdmin.register Segment do
  permit_params :name,
                :color,
                :sequence

  config.filters = true
  config.sort_order = 'sequence_asc'

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
      f.input :sequence,
              as: :select,
              collection: sequence_options(Segment),
              selected: segment.sequence.present? ? segment.sequence : sequence_options(Segment).last
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :sequence
    column :name
    column :color do |segment|
      raw "<div class='pick_color'>#{segment.color}</div>"
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :sequence
      row :name
      row :color do |segment|
        raw "<div class='pick_color'>#{segment.color}</div>"
      end
    end
  end
end
