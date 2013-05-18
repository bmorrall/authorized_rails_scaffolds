module DeviseCanCanRequestMacros

  def sign_in_user(user=nil)
    before(:each) do
      user ||= FactoryGirl.create(:user)
      post user_session_path, :user => { :email => user.email, :password => user.password }
    end
  end
  

end