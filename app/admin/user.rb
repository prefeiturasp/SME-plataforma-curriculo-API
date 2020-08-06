ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin

  config.filters = true

  filter :name
  filter :username
  filter :email
  filter :admin
  filter :dre
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :name do |user|
      span user.admin? ? "-" : user.teacher.name
    end
    column :username
    column :dre
    column :kind do |user|
      span user.admin? ? 'Administrador(a)' : 'Professor(a)'
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at

    actions defaults: true do |user|
      unless user.teacher.blank?
        #
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin, as: :select,
                      collection: [['Sim', true], ['Não', false]],
                      selected: user.admin,
                      include_blank: false
    end
    f.actions
  end

  controller do
    def update
      %w[password password_confirmation].each { |p| params[:user].delete(p) } if params[:user][:password].blank?
      super
    end
  end
end
