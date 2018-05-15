module ControllerMacros
  def login_superadmin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      superadmin = create :user, :superadmin
      sign_in superadmin, scope: :user
    end
  end

  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create :user
      sign_in user, scope: :user
    end
  end
end
