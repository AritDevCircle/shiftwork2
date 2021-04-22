class ShiftsController < ApplicationController
  before_action :logged_in_user
  before_action :set_shift, only: %i[ show edit update destroy take drop ]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if current_user.has_org?
      @shifts = Shift.where(organization_id: current_org_id).order("updated_at DESC") 
    else
      @shifts = Shift.all.order("updated_at DESC")
    end
  end

  def show
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params.merge(organization_id: current_org_id))
    if @shift.save
      flash[:success] = "Shift created successfully!"
      redirect_to organization_path(current_org_id)
    else
      flash[:danger] = @shift.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def update
    if @shift.update(shift_params)
      flash[:success] = "Shift updated successfully!"
      redirect_to organization_path(current_org_id)
    else
      flash[:danger] = @shift.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shift.destroy
    if @shift.destroyed?
      flash[:success] = "Shift deleted successfully!"
      redirect_to organization_path(current_org_id)
    else
      flash[:danger] = @shift.errors.full_messages.to_sentence
    end
  end

  def take
    if @shift.worker_id
      flash[:danger] = "This Shift is already taken!"
      redirect_to shifts_path
    else
      @shift.update_columns(worker_id: current_user.id, shift_open: false)
      flash[:success] = "Shift has been assigned to you successfully!"
      redirect_to worker_path(current_user.worker_account.id)
    end
  end

  def drop
    if @shift.worker_id != current_user.id
      flash[:danger] = "Shift is NOT assigned to you; cannot drop."
    else
      @shift.update_columns(worker_id: nil, shift_open: true)
      flash[:success] = "Shift has been dropped successfully!"
    end
    redirect_to worker_path(current_user.worker_account.id)
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @shift
  end

  def current_org_id
    puts "\n\n\nCurrent User ID: #{current_user.id}\n\n\n"
    return Organization.where(user_id: current_user.id).pluck(:id).first
  end

  def shift_params
    params.require(:shift).permit(:shift_open, :shift_role, :shift_description, :shift_start, :shift_end, :shift_pay, :organization_id, :worker_id)
  end
end
