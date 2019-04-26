ActiveAdmin.register Result do
  actions :all, except: [:new]

  controller do
    def index
#      collection = [{}]

      super do |format|
        format.html
      end
    end
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
