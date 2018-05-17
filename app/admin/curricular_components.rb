ActiveAdmin.register CurricularComponent do
  permit_params :name, axes_attributes: %i[id description _destroy _create _update]

  filter :axes, collection: Axis.all.map { |a| [a.description, a.id] }, as: :select

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end

    panel 'Axes' do
      table_for curricular_component.axes do
        column :description
      end
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
    end

    f.inputs 'Contacts' do
      f.has_many :axes do |c|
        c.input :description
      end
    end

    f.actions
  end
end
