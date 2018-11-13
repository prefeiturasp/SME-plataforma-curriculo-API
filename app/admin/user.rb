ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin

  config.filters = false

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin, as: :select, collection: [["Sim", true], ["Não", false]], selected: user.admin, include_blank: false
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
