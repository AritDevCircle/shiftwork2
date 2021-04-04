class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show edit update]
  before_action :set_user, only: %i[ show edit update ]

  def index
    @open_shifts = Shift.where(shift_open: true).order("updated_at DESC")
  end

  def show
    @user_org = Organization.where(user_id: @user.id).first
  end

  def new
    @user = User.new
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
  end

  def user_update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
