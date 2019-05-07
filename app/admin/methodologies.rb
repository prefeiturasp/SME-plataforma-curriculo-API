ActiveAdmin.register Methodology do
  actions :all, except: [:new]

  permit_params :title,
                :slug,
                :icon,
                :description,
                :content,
                steps_attributes: [:id, :title, :description, :image]

  index do
    render 'index', context: self
  end

  form do |f|
    render 'form', f: f, methodology: methodology
  end

  show do
    render 'show', context: self
  end
end
