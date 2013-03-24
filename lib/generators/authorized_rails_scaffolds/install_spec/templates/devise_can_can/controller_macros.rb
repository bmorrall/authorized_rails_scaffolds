module DeviseCanCanControllerMacros
  def login_unauthorized_user
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @controller.stubs(:current_ability).returns(@ability)

      @request.env["devise.mapping"] = Devise.mappings[:user]
      @logged_in_user = FactoryGirl.create(:user)
      sign_in @logged_in_user
    end
  end
  def login_user_with_ability(action, subject)
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can action, subject
      @controller.stubs(:current_ability).returns(@ability)

      @request.env["devise.mapping"] = Devise.mappings[:user]
      @logged_in_admin = FactoryGirl.create(:user)
      sign_in @logged_in_admin
    end
  end
end
