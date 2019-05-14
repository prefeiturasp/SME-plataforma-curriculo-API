ActiveAdmin.register Result do
  actions :all, except: [:new]

  config.sort_order = 'created_at_asc'
  config.filters = true

  filter :challenge
  filter :created_at
  filter :finished, label: "Desafio Finalizado",
         as: :select, collection: [["Sim", 'yes'], ["Não", 'no']]

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
        link_to result.teacher.name, admin_user_path(id: result.teacher.user.id)
      end
      row :challenge do |result|
        link_to result.challenge.title, admin_challenge_path(id: result.challenge.id)
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

  xls(
    i18n_scope: [:activerecord, :attributes, :result],
    header_format: { weight: :bold, color: :blue }
  ) do
    whitelist

    column :id
    column :teacher do |result|
      result.teacher.name
    end
    column :challenge do |result|
      result.challenge.title
    end
    column :description
    column :created_at
  end
end
