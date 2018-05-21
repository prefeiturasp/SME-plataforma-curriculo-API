ActiveAdmin.register CurricularComponent do
  permit_params :name, axes_attributes: %i[id description _destroy _create _update]

  config.filters = false

  show do
    attributes_table do
      row :name
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
    end

    f.inputs I18n.t('activerecord.models.axis', count: 2) do
      f.has_many :axes do |c|
        c.input :description
      end
    end

    f.actions
  end
end
