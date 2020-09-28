ActiveAdmin.register User do
  permit_params :username, :email, :password, :password_confirmation, :admin, :superadmin, permitted_action_ids: []

  config.filters = true

  filter :name
  filter :username
  filter :superadmin
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
    column :superadmin
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
      f.input :username
      f.input :password
      f.input :password_confirmation
      f.input :admin, as: :select,
                      collection: [['Sim', true]],
                      selected: user.admin,
                      include_blank: false
      f.input :superadmin, as: :select
      f.input :permitted_actions, as: :check_boxes,
                                  input_html: { multiple: true }
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
