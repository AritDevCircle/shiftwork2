module SpecTestHelper
  def login_as(user_email, user_password)
    post "/login", params: { session: { email: user_email, password: user_password } }
  end

  def logout_user
    delete "/logout"
  end

  def current_user
    User.find(session[:user_id])
  end
end