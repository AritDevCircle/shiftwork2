class WorkersController < ApplicationController
  before_action :logged_in_user, only: %i[index show new create edit update]
  before_action :set_worker, only: %i[show edit update]
  before_action :verify_access, only: %i[show edit update]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  
  def index
  end

  def show
    @worker_shifts = Shift.where(worker_id: current_user.worker_account.id).order("updated_at DESC")
  end

  def new
    @worker = Worker.new
  end

  def edit
  end

  def create
    @worker = Worker.new(worker_params.merge(user_id: current_user.id))
    if @worker.save
      flash[:success] = "Worker Account created successfully!"
      redirect_to user_path(current_user.id)
    else
      flash[:error] = "Something went wrong."
      render 'new'
    end
  end

  def update
    if @worker.update(worker_params)
      flash[:success] = "Worker Account updated successfully!"
      redirect_to @worker
    else
      flash[:danger] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_worker
    @worker = Worker.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @worker
  end

  # only the worker logged in has access to the worker actions
  def verify_access
    unless current_user.id == @worker.user_id
      flash[:warning] = "You do not have authority to access that."
      redirect_to user_path(current_user.id)
    end
  end

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :worker_city, :worker_state, :user_id)
  end
end
