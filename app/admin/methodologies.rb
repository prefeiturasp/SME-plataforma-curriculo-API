ActiveAdmin.register Methodology do
  actions :all, except: [:new]

  permit_params :title,
                :slug,
                :image,
                :description,
                :content,
                steps_attributes: [:id, :title, :description, :image]

  form do |f|
    f.inputs 'Metodologia' do
      f.input :title
      f.input :image, as: :file, hint: f.object.image.attached? \
        ? image_container(f.object.image, :thumb)
        : content_tag(:span, "Ainda não há pré-visualização")
      f.input :description

      if f.object.steps.blank?
        f.input :archive, as: :file
        f.input :content, as: :quill_editor, label: false, class: 'bullet-fields', input_html: {
          data: {
            options: {
              modules: {
                formula: true,
                toolbar: [['bold', 'italic','underline', 'strike', 'link', 'blockquote', 'list', 'sub', 'super', 'formula']]
              },
              formats: ['bold', 'italic', 'underline', 'strike', 'link', 'blockquote'],
              theme: 'snow'
            }
          }
        }
      end
    end

    if f.object.title == 'Projeto' || !f.object.steps.blank?
      f.has_many :steps do |step|
        step.input :title
        step.input :image, as: :file, hint: step.object.image.attached? \
          ? image_container(step.object.image, :thumb)
          : content_tag(:span, "Ainda não há pré-visualização")
        step.input :description
      end
    end

    f.submit
  end

  index do
    selectable_column
    column :image do |i|
      image_tag variant_url(i.image, :icon) if i.image.attached?
    end
    column :title
    column :updated_at
    actions
  end

#  show do
#    render 'show', context: self
#  end
end
