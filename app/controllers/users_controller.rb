class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show edit update]
  before_action :set_user, only: %i[ show edit update ]
  before_action :verify_access, only: %i[show edit update]

  def index
  end

  def show
    @user_org = Organization.where(user_id: @user.id).first
  end

  def new
    if logged_in?
        flash[:danger] = "Already logged in. Sign out first to create a new account."
        return redirect_to root_url
    else
        @user = User.new
    end
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Account created successfully! Please login below."
      redirect_to login_path
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_update_params)
      flash[:success] = "Account updated successfully!"
      redirect_to @user
    else
      flash[:danger] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @user
  end

  # only the organization logged in has access to the organization actions
  def verify_access
    unless current_user.id == @user.id
      flash[:alert] = "You do not have authority to access that."
      redirect_to user_path(current_user.id)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
  end

  def user_update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
