ActiveAdmin.register CurricularComponent do
  permit_params :name, axes_attributes: %i[id year description _destroy _create _update]

  config.filters = false

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.axis', count: 2) do
      table_for curricular_component.axes do
        column :description
        column :year do |curricular_component|
          CurricularComponent.human_enum_name(:year, curricular_component.year, true)
        end
      end
    end
  end

  form do |f|
    f.inputs CurricularComponent.human_attribute_name(:details) do
      f.input :name
    end

    f.inputs I18n.t('activerecord.models.axis', count: 2) do
      f.has_many :axes do |c|
        c.input :year, as: :select, collection: human_attribute_years
        c.input :description
      end
    end

    f.actions
  end
end
