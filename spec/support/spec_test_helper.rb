module SpecTestHelper
  def login_as(user)
    post "/login", params: { session: { email: user.email, password: user.password } }
  end

  def current_user
    User.find(session[:user_id])
  end
end