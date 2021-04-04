class OrganizationsController < ApplicationController
  before_action :logged_in_user, only: %i[show new create edit update]
  before_action :set_organization, only: %i[ show edit update ]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  
  def index

  end

  def show
    @org_shifts = Shift.where(organization_id: @organization.id).order("updated_at DESC")
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params.merge(user_id: current_user.id))
    if @organization.save
      flash[:success] = "Organization created successfully!"
      redirect_to user_path(current_user.id)
    else
      flash[:error] = "Something went wrong."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      flash[:success] = "Organization updated successfully!"
      redirect_to @organization
    else
      flash[:danger] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @organization
  end

  def organization_params
    params.require(:organization).permit(:org_name, :org_description, :org_address, :org_city, :org_state, :user_id)
  end
end
