ActiveAdmin.register CurricularComponent do
  permit_params :name,
                :color,
                axes_attributes: %i[id description _destroy _create _update]

  config.filters = false

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column :name
    column :slug
    column :color do |curricular_component|
      raw "<div class='pick_color'>#{curricular_component.color}</div>"
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :slug
      row :color do |curricular_component|
        raw "<div class='pick_color'>#{curricular_component.color}</div>"
      end
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.axis', count: 2) do
      table_for curricular_component.axes do
        column :description
      end
    end
  end

  form do |f|
    f.inputs CurricularComponent.human_attribute_name(:details) do
      f.input :name
      f.input :color, as: :color
    end

    f.inputs I18n.t('activerecord.models.axis', count: 2) do
      f.has_many :axes do |c|
        c.input :description
      end
    end

    f.actions
  end
end
