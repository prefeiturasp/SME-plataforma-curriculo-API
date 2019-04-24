ActiveAdmin.register Result do
#  permit_params :description,
#                :curricular_component_id

#  config.filters = false

  controller do
#    def destroy
#      @axis = Axis.find(params[:id])
#      flash[:error] = @axis.errors.full_messages.join(',') unless @axis.destroy
#      redirect_to action: :index
#    end
  end

  form do |f|
#    f.inputs do
#      f.input :description
#      f.input :curricular_component
#    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column do |result|
      link_to result.teacher.name, "javascript:void(0);"
    end
    column do |result|
      link_to result.challenge.title, "javascript:void(0);"
    end
    column do |result|
      truncate result.description, omision: "...", length: 100
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row do |result|
        link_to result.teacher.name, "javascript:void(0);"
      end
      row do |result|
        link_to result.challenge.title, "javascript:void(0);"
      end
      row do |result|
        ul do
          results.links.each do |link|
            li link_to link.link, link.link
          end
        end
      end
      row :description

      row :created_at
    end
  end
end
