module DeviseCanCanRequestMacros

  def sign_in_user(user=nil)
    user ||= FactoryGirl.create(:user)
    post user_session_path, :user => { :email => user.email, :password => user.password }
  end

end