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
    column :teacher do |result|
      link_to result.teacher.name, admin_user_path(id: result.teacher.user.id)
    end
    column :challenge do |result|
      link_to result.challenge.title, admin_challenge_path(id: result.challenge.id)
    end
    column :description do |result|
      truncate result.description, omision: "...", length: 100
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :teacher do |result|
        link_to result.teacher.name, "javascript:void(0);"
      end
      row :challenge do |result|
        link_to result.challenge.title, "javascript:void(0);"
      end
      row :links do |result|
        ul do
          result.links.each do |link|
            li link_to link.link, link.link
          end
        end
      end
      row :archive do |result|
        link_to result.archive.filename, url_for(result.archive)
      end
      row :description

      row :created_at
    end
  end
end
