class ApplicationController < ActionController::Base
  include SessionsHelper

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  private
  def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
  end
end
