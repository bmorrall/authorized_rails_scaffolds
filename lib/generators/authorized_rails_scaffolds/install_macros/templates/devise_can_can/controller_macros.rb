module DeviseCanCanControllerMacros

  module ClassMethods
    def grant_ability(action, subject)
      before(:each) do
        stub_ability.can action, subject
      end
    end

    def login_unauthorized_user
      before(:each) do
        stub_ability

        @request.env["devise.mapping"] = Devise.mappings[:user]
        @logged_in_user = FactoryGirl.create(:user)
        sign_in @logged_in_user
      end
    end

    def login_user_with_ability(action, subject)
      before(:each) do
        stub_ability.can action, subject

        @request.env["devise.mapping"] = Devise.mappings[:user]
        @logged_in_user = FactoryGirl.create(:user)
        sign_in @logged_in_user
      end
    end
  end

  def self.included(controller_spec)
    controller_spec.extend(ClassMethods)
  end

  def stub_ability
    unless @ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @controller.stub(:current_ability).and_return(@ability)
    end
    @ability
  end

end
